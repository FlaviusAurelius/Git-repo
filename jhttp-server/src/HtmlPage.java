public class HtmlPage {

    public static final String NOT_FOUND = new StringBuilder("<HTML>\r\n")
            .append("<HEAD><TITLE>File Not Found</TITLE>\r\n")
            .append("</HEAD>\r\n")
            .append("<BODY>")
            .append("<H1>HTTP Error 404: File Not Found</H1>\r\n")
            .append("</BODY></HTML>\r\n").toString();

    public static final String REGISTERED = new StringBuilder("<HTML>\r\n")
            .append("<HEAD><TITLE>Registration</TITLE>\r\n")
            .append("</HEAD>\r\n")
            .append("<BODY>")
            .append("<H1>Registration Successful</H1>\r\n")
            .append("</BODY></HTML>\r\n").toString();

    public static final String NOT_IMPLEMENTED = new StringBuilder("<HTML>\r\n")
            .append("<HEAD><TITLE>Not Implemented</TITLE>\r\n")
            .append("</HEAD>\r\n")
            .append("<BODY>")
            .append("<H1>HTTP Error 501: Not Implemented</H1>\r\n")
            .append("</BODY></HTML>\r\n").toString();

    public static final String INTERNAL_SERVER_ERROR = new StringBuilder("<HTML>\r\n")
            .append("<HEAD><TITLE>Server Error</TITLE>\r\n")
            .append("</HEAD>\r\n")
            .append("<BODY>")
            .append("<H1>HTTP Error 500: Internal Server Error</H1>\r\n")
            .append("</BODY></HTML>\r\n").toString();

    public static final String FORBIDDEN = new StringBuilder("<HTML>\r\n")
            .append("<HEAD><TITLE>No Authorization</TITLE>\r\n")
            .append("</HEAD>\r\n")
            .append("<BODY>")
            .append("<H1>HTTP Error 403: Forbidden, Authorization not found</H1>\r\n")
            .append("</BODY></HTML>\r\n").toString();


    public static String BAD_REQUEST(String message) {

        return new StringBuilder("<HTML>\r\n")
                .append("<HEAD><TITLE>Bad Request</TITLE>\r\n")
                .append("</HEAD>\r\n")
                .append("<BODY>")
                .append("<H1>HTTP Error 400: Bad Request, ").append(message).append("</H1>\r\n")
                .append("</BODY></HTML>\r\n").toString();
    }

    public static final String UNAUTHORIZED = new StringBuilder("<HTML>\r\n")
            .append("<HEAD><TITLE>Unauthorized</TITLE>\r\n")
            .append("</HEAD>\r\n")
            .append("<BODY>")
            .append("<H1>HTTP Error 401: Unauthorized, Invalid username or password</H1>\r\n")
            .append("</BODY></HTML>\r\n").toString();
            
}
