public class QBOWebhookWrapper {
	
    public List<EventNotification> eventNotifications;
    
    public class EventNotification {
        public String realmId;
        public Event dataChangeEvent;
    }
    
    public class Event {
        public List<Entity> entities;
    }
    
    public class Entity {
        public String id;
        public String name;
        public String operation;
        public String lastUpdated;
    }
}