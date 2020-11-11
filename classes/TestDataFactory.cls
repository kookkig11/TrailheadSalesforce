/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
//@IsTest
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup constructCollaborationGroup() {
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constantc [class]
        //    and configured so anyone can join, see and post updates.
        return new CollaborationGroup(
            Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
            CollaborationType = 'Public',   // config user can join/see/post
            IsArchived = false,
            IsAutoArchiveDisabled = true);
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> constructProducts(Integer cnt) {
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.

        Integer familySize = Constants.PRODUCT_FAMILY.size();
        List<Product2> products = new List<Product2>();
        for(Integer i = 0; i < cnt; i++) {
            products.add(new Product2(
                Name = 'TEST' + String.valueOf(i),
                IsActive = true,
                Initial_Inventory__c = 10,
                Family = Constants.PRODUCT_FAMILY[Math.mod(i, familySize)].getValue()));
        }
        return products;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> constructPricebookEntries(List<Product2> prods) {
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook

        List<PricebookEntry> entries = new List<PricebookEntry>();
        for(Product2 product : prods) {
            entries.add(new PricebookEntry(
                Product2Id = product.Id,
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                UnitPrice = 10.0,
                IsActive = true));
        }
        return entries;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> constructAccounts(Integer cnt) {
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.

        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < cnt; i++) {
            accounts.add(new Account(
                Name = 'Test Account-' + String.valueOf(i)));
        }
        return accounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> constructContacts(Integer cnt, List<Account> accts) {
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.

        List<Contact> contacts = new List<Contact>();
        Integer accountsSize = accts.size();

        for(Integer i = 0; i < cnt; i++) {
            Integer accountIndex = Math.mod(i, accountsSize);
            contacts.add(new Contact(
                LastName = accts[accountIndex].Name + '-CONTACT-' + String.valueOf(i),
                AccountId = accts[accountIndex].Id));
        }
        return contacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> constructOrders(Integer cnt, List<Account> accts) {
        List<Order> orders = new List<Order>();
        Integer accountsSize = accts.size();

        for(Integer i = 0; i < cnt; i++) {
            Integer accountIndex = Math.mod(i, accountsSize);
            orders.add(new Order(
                Name = accts[accountIndex].Name + '-ORDER-' + String.valueOf(i),
                AccountId = accts[accountIndex].Id,
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                EffectiveDate = Date.today(),
                Status = Constants.DRAFT_ORDER_STATUS));
        }
        return orders;
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> constructOrderItems(Integer cnt, List<PricebookEntry> pbes, List<Order> ords) {
        List<OrderItem> items = new List<OrderItem>();
        Integer pbeSize = pbes.size();
        Integer ordersSize = ords.size();

        for(Integer i = 0; i < cnt; i++) {
            Integer pbeIndex = Math.mod(i, pbeSize);
            Integer orderIndex = Math.mod(i, ordersSize);

            items.add(new OrderItem(
                PricebookEntryId = pbes[pbeIndex].Id,
                OrderId = ords[orderIndex].Id,
                Quantity = Constants.DEFAULT_ROWS,
                UnitPrice = 10));
        }
        return items;
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void insertTestData(Integer cnt) {
        CollaborationGroup chatterGroup = constructCollaborationGroup();
        insert chatterGroup;
        List<Product2> products = constructProducts(cnt);
        insert products;
        List<PricebookEntry> entries = constructPricebookEntries(products);
        insert entries;
        List<Account> accounts = constructAccounts(cnt);
        insert accounts;
        List<Contact> contacts = constructContacts(cnt, accounts);
        insert contacts;
        List<Order> orders = constructOrders(cnt, accounts);
        insert orders;
        List<OrderItem> items = constructOrderItems(cnt, entries, orders);
        insert items;
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
    }

    public static void verifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals(originalProduct.Quantity_Ordered__c + qtyOrdered, updatedProduct.Quantity_Ordered__c, 'Updated Qty should equal the sum of original with the qty ordered.');
    }
}