package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.model;

public class Conversation {
    private int id;
    private int participantId;
    private String participantName;
    private String participantAvatar;
    private String lastMessage;
    private int lastSenderId;
    private String lastMessageTime;
    private boolean hasUnread;

    public Conversation() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getParticipantId() {
        return participantId;
    }

    public void setParticipantId(int participantId) {
        this.participantId = participantId;
    }

    public String getParticipantName() {
        return participantName;
    }

    public void setParticipantName(String participantName) {
        this.participantName = participantName;
    }

    public String getParticipantAvatar() {
        return participantAvatar;
    }

    public void setParticipantAvatar(String participantAvatar) {
        this.participantAvatar = participantAvatar;
    }

    public String getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }

    public int getLastSenderId() {
        return lastSenderId;
    }

    public void setLastSenderId(int lastSenderId) {
        this.lastSenderId = lastSenderId;
    }

    public String getLastMessageTime() {
        return lastMessageTime;
    }

    public void setLastMessageTime(String lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }

    public boolean isHasUnread() {
        return hasUnread;
    }

    public void setHasUnread(boolean hasUnread) {
        this.hasUnread = hasUnread;
    }
}
