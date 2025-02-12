import javax.net.ssl.SSLSocket;
import java.io.*;
import java.net.SocketException;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

import static java.lang.String.format;

public class RequestProcessor implements Runnable {

    private final static Logger logger = Logger.getLogger(RequestProcessor.class.getCanonicalName());

    private File rootDirectory;
    private String indexFileName = "index.html";
    private static final Charset ENCODING = StandardCharsets.UTF_8;
    private SSLSocket sslSocket;

    private List<String> userEncodedCredentials = new ArrayList<>();
    private String basicAuthToken = "unauthorized";

    public RequestProcessor(File rootDirectory, String indexFileName, SSLSocket sslSocket, List<String> users) {

        if (rootDirectory.isFile()) {
            throw new IllegalArgumentException(
                    "rootDirectory must be a directory, not a file");
        }

        try {
            rootDirectory = rootDirectory.getCanonicalFile();
        } catch (IOException ex) {
        }

        this.rootDirectory = rootDirectory;

        if (indexFileName != null) {
            this.indexFileName = indexFileName;
        }

        this.sslSocket = sslSocket;
        this.userEncodedCredentials = users;
    }

    // This is the authorization function used to check whether 
    //  a user is allowed to access a resource or not.

    // For now as long as you have a username and password on record
    //  you can access content inside jhttp. 
    private String getAuthorizationStatus(List<String> headers) throws IOException {

        //check for Basic Auth
        for (String header : headers) {

            if (header.contains("Authorization:")) {
                basicAuthToken = header.split(" ")[2].trim();
                System.out.println("Basic Auth Token: " + basicAuthToken);
            }
        }
        // Case: If the provided credential does not exist on record
        if (basicAuthToken.equals("unauthorized")) {
            return "unauthorized";
        // Case: Username and PW mismatch
        } else if (isNotAuthorized(basicAuthToken)) {
            return "invalid";
        }

        return "authorized";
    }

    @Override
    public void run() {

        // for security checks
        String root = rootDirectory.getPath();

        while (true) {

            try (BufferedReader requestStream
                         = new BufferedReader(new InputStreamReader(sslSocket.getInputStream(), ENCODING));
                 // The server writes its response to the socket's output stream
                 BufferedOutputStream responseStream = new BufferedOutputStream(sslSocket.getOutputStream())) {

                byte[] response;
                ResourceInfo resourceInfo = new ResourceInfo();

                //get the header of the request
                List<String> headers = getHeaders(requestStream);

                // prints to show more information about requests
                System.out.println();
                System.out.println("Headers:");
                System.out.println(headers);

                //get the http method
                String httpMethod = headers.get(0).split(" ")[0];

                //get the requested resource
                String requestedResource = getRequestedResource(headers, requestStream).orElse("unknown");

                System.out.println();
                System.out.println("Requested Resource: " + requestedResource);

                switch (httpMethod) {
                    // This is here so that if GET request comes, it doesn't immediately
                    //  fall into default since we do have GET implemented
                    case "GET":{
                    }

                    // Due to the similarity in function of our implementation of GET and HEAD, 
                    //  it is combined into one case
                    case "HEAD": {
                        // This is beginning of HEAD
                        String authorizationStatus = getAuthorizationStatus(headers);

                        // If the user's not authorized
                        if (authorizationStatus.equals("unauthorized")) {
                            // and it's GET request, show the following error msg
                            if(httpMethod.equals("GET")) {
                                resourceInfo.setBody(HtmlPage.FORBIDDEN);
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);
                            }
                            // and it's HEAD request, show the following error msg
                            response = getResponse(resourceInfo, Constant.FORBIDDEN_RESPONSE_CODE);
                            break;
                        }
                        // If the user's credential is invalid
                        if (authorizationStatus.equals("invalid")) {
                            // and it's GET request, show the following error msg
                            if(httpMethod.equals("GET")) {
                                resourceInfo.setBody(HtmlPage.UNAUTHORIZED);
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);
                            }
                            // and it's HEAD request, show the following error msg
                            response = getResponse(resourceInfo, Constant.UNAUTHORIZED_RESPONSE_CODE);
                            break;
                        }
                        // the user passes authentication, now attempt to fetch the requested resource
                        String contentType = URLConnection.getFileNameMap().getContentTypeFor(requestedResource);
                        System.out.println(contentType);
                        File theFile = new File(rootDirectory, requestedResource.substring(1, requestedResource.length()));
                        
                        if (theFile.canRead()
                                // Don't let clients outside the document root
                                && theFile.getCanonicalPath().startsWith(root)) {
                            byte[] theData = Files.readAllBytes(theFile.toPath());

                            resourceInfo.setName(requestedResource);
                            resourceInfo.setContentType(contentType);
                            resourceInfo.setContentLength(theData.length);

                            if (httpMethod.equals("GET")) {
                                response = getFileResponse(theFile, contentType);

                            } else {   
                                response = getResponse(resourceInfo, Constant.OK_RESPONSE_CODE);
                            }

                        } else { // can't find the resource

                            if (httpMethod.equals("GET")) {
                                resourceInfo.setBody(HtmlPage.NOT_FOUND);
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);
                            }

                            resourceInfo.setName(requestedResource);
                            response = getResponse(resourceInfo, Constant.NOT_FOUND_RESPONSE_CODE);
                        }

                        break;
                    } //this is end of HEAD

                    case "POST": {
                        // this is start of POST
                        String authorizationStatus = getAuthorizationStatus(headers);

                        List<String> url = List.of(requestedResource.split("\\?", 2));
                        System.out.println(url);

                        if (url.isEmpty()) {

                            if (!requestedResource.equals("/register")) {

                                if (authorizationStatus.equals("unauthorized")) {
                                    resourceInfo.setBody(HtmlPage.FORBIDDEN);
                                    resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                                    response = getResponse(resourceInfo, Constant.FORBIDDEN_RESPONSE_CODE);
                                    break;
                                }

                                if (authorizationStatus.equals("invalid")) {
                                    resourceInfo.setBody(HtmlPage.UNAUTHORIZED);
                                    resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                                    response = getResponse(resourceInfo, Constant.UNAUTHORIZED_RESPONSE_CODE);
                                    break;
                                }

                                resourceInfo.setBody(HtmlPage.NOT_FOUND);
                                resourceInfo.setContentType(Constant.NOT_FOUND_RESPONSE_CODE);

                                response = getResponse(resourceInfo, Constant.BAD_REQUEST_CODE);
                                break;
                            }

                            resourceInfo.setBody(HtmlPage.BAD_REQUEST("Please provide username and password parameters"));
                            resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                            response = getResponse(resourceInfo, Constant.BAD_REQUEST_CODE);
                            break;
                        }

                        if (url.get(0).equals("/register")) {

                            Map<String, String> credentials = new HashMap<>();

                            String parameterStrings = url.get(1);

                            List<String> parameters = List.of(parameterStrings.split("&"));

                            if (parameters.isEmpty() || parameters.size() < 2) {

                                resourceInfo.setBody(HtmlPage.BAD_REQUEST("Please provide valid username and password parameters"));
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                                response = getResponse(resourceInfo, Constant.BAD_REQUEST_CODE);
                                break;
                            }

                            boolean parameterIsInvalid = false;

                            for (String parameter : parameters) {

                                List<String> parameterTokens = List.of(parameter.split("=", 2));

                                if (parameterTokens.isEmpty() || parameterTokens.size() < 2) {
                                    parameterIsInvalid = true;
                                    break;
                                }

                                credentials.put(parameterTokens.get(0), parameterTokens.get(1));
                            }

                            if (parameterIsInvalid) {
                                resourceInfo.setBody(HtmlPage.BAD_REQUEST("Invalid Parameters, please provide username and password parameters only"));
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                                response = getResponse(resourceInfo, Constant.BAD_REQUEST_CODE);
                                break;
                            }

                            if (!credentials.containsKey("username") || !credentials.containsKey("password")) {

                                resourceInfo.setBody(HtmlPage.BAD_REQUEST("username or password parameter not found"));
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                                response = getResponse(resourceInfo, Constant.BAD_REQUEST_CODE);
                                break;
                            }

                            if (credentials.get("username").isBlank() || credentials.get("password").isBlank()) {

                                resourceInfo.setBody(HtmlPage.BAD_REQUEST("username or password is blank"));
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                                response = getResponse(resourceInfo, Constant.BAD_REQUEST_CODE);
                                break;
                            }

                            User user = new User();
                            user.setUsername(credentials.get("username"));
                            user.setPassword(credentials.get("password"));

                            String status = saveUser(user);

                            if (status.equals("exists")) {
                                resourceInfo.setBody(HtmlPage.BAD_REQUEST("Username already exists"));
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                                response = getResponse(resourceInfo, Constant.BAD_REQUEST_CODE);
                                break;
                            }

                            if (status.equals("exception")) {
                                resourceInfo.setBody(HtmlPage.INTERNAL_SERVER_ERROR);
                                resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                                response = getResponse(resourceInfo, Constant.INTERNAL_SERVER_ERROR);
                                break;
                            }

                            resourceInfo.setBody(HtmlPage.REGISTERED);
                            resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                            response = getResponse(resourceInfo, Constant.OK_RESPONSE_CODE);

                        } else { // can't find resource

                            resourceInfo.setBody(HtmlPage.NOT_FOUND);
                            resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                            response = getResponse(resourceInfo, Constant.NOT_FOUND_RESPONSE_CODE);
                        }

                        break;
                    }// this is end of POST

                    default: {

                        resourceInfo.setBody(HtmlPage.NOT_IMPLEMENTED);
                        resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

                        response = getResponse(resourceInfo, Constant.NOT_IMPLEMENTED_RESPONSE_CODE);
                        break;
                    }
                }

                responseStream.write(response);

                // It's important to flush the response stream before closing it to make sure any
                // unsent bytes in the buffer are sent via the socket. Otherwise, the client gets an
                // incomplete response
                responseStream.flush();

            } catch (SocketException e) {
                //socket stream closed

            } catch (IOException e) {
                logger.log(Level.WARNING,
                        "Error talking to " + sslSocket.getRemoteSocketAddress(), e);
                break;
            }
        }
    }

    private boolean isNotAuthorized(String authInfo) {

        String credentials = new String(Base64.getDecoder().decode(authInfo));
        System.out.println("User: " + credentials);

        return !userEncodedCredentials.contains(authInfo);
    }

    private static String createEncodedCredentials(final String username, final String password) {
        final String pair = username + ":" + password;
        final byte[] encodedBytes = Base64.getEncoder().encode(pair.getBytes());
        return new String(encodedBytes);
    }

    private List<String> getHeaders(BufferedReader reader) {

        List<String> headerLines = new ArrayList<>();

        try {

            String line = reader.readLine();

            // The header is concluded when we see an empty line.
            // The line is null if the end of the stream was reached without reading
            // any characters. This can happen if the client tries to connect with
            // HTTPS while the server expects HTTP

            while (line != null && !line.isEmpty()) {
                headerLines.add(line);
                line = reader.readLine();
            }

        } catch (IOException e) {
            System.err.println("Could not read all lines from request");
            e.printStackTrace();
        }

        return headerLines;
    }

    private Optional<String> getRequestedResource(List<String> headers, BufferedReader requestStream) {

        return first(headers).map(statusLine -> {
            // Go past the space
            int beginIndex = statusLine.indexOf(' ') + 1;
            int endIndex = statusLine.lastIndexOf(' ');
            return statusLine.substring(beginIndex, endIndex);
        });
    }

    private <E> Optional<E> first(List<? extends E> list) {
        return (list != null && !list.isEmpty()) ?
                Optional.ofNullable(list.get(0)) :
                Optional.empty();
    }

    private static byte[] concat(byte[] first, byte[] second) {
        // New array with contents of first one, having the length of the two input arrays combined
        byte[] result = Arrays.copyOf(first, first.length + second.length);
        // Copy the second array into the result array starting at the end of the first array
        System.arraycopy(second, 0, result, first.length, second.length);
        return result;
    }

    private byte[] getResponse(ResourceInfo resourceInfo, String responseCode) {

        String body = resourceInfo.getBody() + "\r\n";
        int contentLength = body.getBytes(ENCODING).length;

        String response = responseCode + "\r\n" +
                format("Server: %s\r\n", "JHTTP") +
                format("Content-Length: %d\r\n", contentLength) +
                format("Content-Type: %s; charset=%s\r\n",
                        resourceInfo.getContentType(), ENCODING.displayName()) +
                format("Resource: %s\r\n", resourceInfo.getName()) +
                "\r\n" + body;

        return response.getBytes(ENCODING);
    }

    private byte[] getFileResponse(File theFile, String fileType) {

        byte[] response;

        try {
            byte[] theData = Files.readAllBytes(theFile.toPath());
            String fileName = theFile.getName();

            String statusLine = Constant.OK_RESPONSE_CODE;
            String server = format("Server: %s\r\n", "JHTTP");
            String contentLength = "Content-Length: " + theData.length;
            String contentType = "Content-Type: " + fileType;
            String contentDisposition = format("Content-Disposition: inline; filename=%s", fileName);

            String header = statusLine + "\r\n" +
                    server + "\r\n" +
                    contentLength + "\r\n" +
                    contentType + "\r\n" +
                    contentDisposition + "\r\n" +
                    "\r\n";

            // Append the bytes of the file to the bytes of the header
            response = concat(header.getBytes(ENCODING), theData);

        } catch (IOException e) {

            ResourceInfo resourceInfo = new ResourceInfo();
            resourceInfo.setBody(HtmlPage.INTERNAL_SERVER_ERROR);
            resourceInfo.setContentType(Constant.HTML_CONTENT_TYPE);

            var msg = format("Could not read file at URL '%s'", theFile.getPath());
            System.err.println(msg);

            response = getResponse(resourceInfo, Constant.INTERNAL_SERVER_ERROR);
        }

        return response;
    }

    // This function is used to register new users
    //  by adding the new entry into users.txt
    private String saveUser(User user) {

        PrintWriter pw = null;

        try {

            //check if user exists
            BufferedReader br = new BufferedReader(new FileReader("users.txt"));
            String line;

            while ((line = br.readLine()) != null) {

                String credentials = new String(Base64.getDecoder().decode(line));

                if (credentials.split(":", 2)[0].equals(user.getUsername())) {
                    return "exists";
                }
            }

            //Creating object of PrintWriter class
            pw = new PrintWriter(new FileWriter("users.txt", true));

            //Writing to the file
            String encodedCredentials = createEncodedCredentials(user.getUsername(), user.getPassword());
            userEncodedCredentials.add(encodedCredentials);
            pw.println(encodedCredentials);

            //Closing the stream
            pw.close();
            System.out.println("User Saved");
            return "saved";

        } catch (Exception e) {
            e.printStackTrace();

        } finally {

            try {
                if (pw != null) {
                    pw.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return "exception";
    }
}