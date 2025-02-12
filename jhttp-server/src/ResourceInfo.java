public class ResourceInfo {

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public Long getContentLength() {
        return contentLength;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setContentLength(long contentLength) {
        this.contentLength = contentLength;
    }

    private String body = "";
    private String name = "";
    private String contentType = Constant.HTML_CONTENT_TYPE;
    private long contentLength;

    private String getKilobytes(long bytes) {
        long kilobytes = bytes / 1024;
        return kilobytes + "kb";
    }
    
}
