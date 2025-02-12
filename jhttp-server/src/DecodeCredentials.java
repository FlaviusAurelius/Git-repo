import java.util.Base64;

public class DecodeCredentials {
    public static void main(String[] args) {
        String encodedCredential1 = "YWRtaW46YWRtaW4="; 


        System.out.println(decodeBase64(encodedCredential1));
    }

    public static String decodeBase64(String encoded) {
        return new String(Base64.getDecoder().decode(encoded));
    }
}
