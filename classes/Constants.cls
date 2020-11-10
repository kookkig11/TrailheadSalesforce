public with sharing class Constants {
    public static final Integer DEFAULT_ROWS =	5;
    public static final String SELECT_ONE =	System.Label.SELECT_ONE;
    public static final String INVENTORY_LEVEL_LOW = System.Label.INVENTORY_LEVEL_LOW;
    public static final List<Schema.PicklistEntry> PRODUCT_FAMILY = Product2.Family.getDescribe().getPickListValues();
    public static final String DRAFT_ORDER_STATUS =	'Draft';
    public static final String ACTIVATED_ORDER_STATUS =	'Activated';
    public static final String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    public static final String ERROR_MESSAGE =	'An error has occurred, please take a screenshot with the URL and send it to IT.';
    // get from query :: developer console
    // SELECT Id FROM PriceBook2 WHERE Name = 'Standard Price Book'
    public static final String STANDARD_PRICEBOOK_ID = '01s2y000001ZLHcAAO';
}
