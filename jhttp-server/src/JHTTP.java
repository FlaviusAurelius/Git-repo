import javax.net.ssl.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyStore;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.concurrent.*;
import java.util.logging.*;

public class JHTTP {

    private static final Logger logger = Logger.getLogger(JHTTP.class.getCanonicalName());
    private static final int NUM_THREADS = 50;
    private static final String INDEX_FILE = "index.html";

    private final File rootDirectory;
    private final int port;

    public JHTTP(File rootDirectory, int port) throws IOException {

        if (!rootDirectory.isDirectory()) {
            boolean rootDirectoryIsCreated = rootDirectory.mkdir();

            if (!rootDirectoryIsCreated) {
                System.err.println("Root Directory Creation Failed");
            }
        }

        this.rootDirectory = rootDirectory;
        this.port = port;
    }


    //Initialize the SSLContext
    private SSLContext createSSLContext() {
        try {
            //This is similar to loading private key, 
            // we need to pass the alias of the certificate we want to extract.
            KeyStore keyStore = KeyStore.getInstance("JKS");
            keyStore.load(Files.newInputStream(Paths.get("./jhttp.jks")), "password".toCharArray());

            // Create key manager
            KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance("SunX509");
            keyManagerFactory.init(keyStore, "password".toCharArray());
            KeyManager[] km = keyManagerFactory.getKeyManagers();

            // Create trust manager
            TrustManagerFactory trustManagerFactory = TrustManagerFactory.getInstance("SunX509");
            trustManagerFactory.init(keyStore);
            TrustManager[] tm = trustManagerFactory.getTrustManagers();

            // Initialize SSLContext
            SSLContext sslContext = SSLContext.getInstance("TLSv1");
            sslContext.init(km, tm, null);

            return sslContext;
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
    }

    public void start() throws IOException {

        //load users
        List<String> users = new ArrayList<>();
        BufferedReader br = new BufferedReader(new FileReader("users.txt"));
        String line;

        System.out.println();
        System.out.println("Users: ");
        // prints users on record in our mock DB
        //  which is all inside users.txt
        while ((line = br.readLine()) != null) {
            System.out.println(new String(Base64.getDecoder().decode(line)));
            users.add(line);
        }

        System.out.println();

        ExecutorService pool = Executors.newFixedThreadPool(NUM_THREADS);

        SSLContext sslContext = this.createSSLContext();

        SSLServerSocketFactory factory =
                (SSLServerSocketFactory) sslContext.getServerSocketFactory();

        //the following code with SSL are pretty much straight out of the textbook
        try (SSLServerSocket serverSocket = (SSLServerSocket) factory.createServerSocket(port)) {
            
            String[] suites = serverSocket.getSupportedCipherSuites();
            String[] protocols = serverSocket.getSupportedProtocols();

            serverSocket.setEnabledCipherSuites(suites);

            logger.info("Accepting connections on port " + serverSocket.getLocalPort());
            logger.info("Document Root: " + rootDirectory);

            // now server does server thing, accept connection, etc.
            while (true) {

                try {
                    SSLSocket sslSocket = (SSLSocket) serverSocket.accept();
                    sslSocket.setEnabledProtocols(protocols);
                    sslSocket.setEnabledCipherSuites(sslSocket.getEnabledCipherSuites());
                    sslSocket.startHandshake();

                    // Get session after the connection is established
                    SSLSession sslSession = sslSocket.getSession();

                    // prints what protocol and cipher suites are used,
                    //  more detail can be seen on the output whenever a request
                    //  was received, connection established, and request processed.
                    System.out.println("SSLSession :");
                    System.out.println("\tProtocol : " + sslSession.getProtocol());
                    System.out.println("\tCipher suite : " + sslSession.getCipherSuite());

                    //process request
                    Runnable r = new RequestProcessor(rootDirectory, INDEX_FILE, sslSocket, users);
                    pool.submit(r);

                } catch (SSLHandshakeException ex) {
                    //expected error because of self-signed certificate
                    System.out.println("Expected error due to self-signed certificate during ssl handshake");
                } catch (IOException ex) {
                    logger.log(Level.WARNING, "Error accepting connection", ex);
                }
            }

        }
    }

    public static void main(String[] args) {

        System.out.println("Welcome to JHHTP \n");

        // get the Document root
        File docroot;

        try {
            docroot = new File(args[0]);

        } catch (ArrayIndexOutOfBoundsException ex) {
            System.out.println("Usage: java JHTTP docroot port");
            docroot = new File("../jhttp");
        }

        //create users.txt file

        try {
            File users = new File("users.txt");

            if (!users.exists()) {
                users.createNewFile();
            }

        } catch (IOException e) {
            System.err.println("users.txt file failed to load");
        }

        // set the port to listen on
        int port;

        try {
            port = Integer.parseInt(args[1]);
            if (port < 0 || port > 65535) port = 80;

        } catch (RuntimeException ex) {
            port = 80;
        }

        try {
            JHTTP webserver = new JHTTP(docroot, port);
            webserver.start();

        } catch (IOException ex) {
            logger.log(Level.SEVERE, "Server could not start", ex);
        }
    }
}
