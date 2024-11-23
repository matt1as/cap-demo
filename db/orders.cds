namespace db;

using { sap.common.CodeList } from '@sap/cds/common';
using { Currency } from '@sap/cds/common';

entity Articles : CodeList {
    key ID : UUID;
    name : String(100);
    price : Decimal(9,2);
    currency : Currency;
    maxRebate : Decimal(3,2);
    remainingStock : Integer;
    createdAt : Timestamp @cds.on.insert: $now;
    createdBy : String(255) @cds.on.insert: $user;
    modifiedAt : Timestamp @cds.on.insert: $now @cds.on.update: $now;
    modifiedBy : String(255) @cds.on.insert: $user @cds.on.update: $user;
}

entity Orders {
    key ID : UUID;
    
    orderDate : Date @cds.on.insert: $now;
    expectedDeliveryDate : Date;
    _status : Association to OrderStatus ;
    _orderLines : Composition of many OrderLines on ID = _orderLines.order.ID;
    orderNumber : Integer @cds.autoincrement @readonly; 
    
    createdAt : Timestamp @cds.on.insert: $now;
    createdBy : String(255) @cds.on.insert: $user;
    modifiedAt : Timestamp @cds.on.insert: $now @cds.on.update: $now;
    modifiedBy : String(255) @cds.on.insert: $user @cds.on.update: $user;
}

entity OrderStatus : CodeList {
key ID    : Integer;
      name  : localized String(255);
      descr : localized String(1000);
}

entity OrderLines {
    key ID : UUID; 
    order : Association to Orders;
    article : Association to Articles @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'db.Articles',
        
    };
    quantity : Integer;
    _status : Association to OrderStatus ;

    createdAt : Timestamp @cds.on.insert: $now;
    createdBy : String(255) @cds.on.insert: $user;
    modifiedAt : Timestamp @cds.on.insert: $now @cds.on.update: $now;
    modifiedBy : String(255) @cds.on.insert: $user @cds.on.update: $user;
}

annotate Orders with {
    orderNumber @title: 'Order Number';
    orderDate @title: 'Order Date';
    ID;
    _orderLines;
    createdAt;
    createdBy;
    modifiedAt;
    modifiedBy;
   _status @( title: 'Order Status', Common.ValueListWithFixedValues, Common.Text: _status.name ); 
    expectedDeliveryDate @title: 'Expected Delivery Date';
}

// Make read only if status is shipped
annotate Orders with @(restrict : [
    {
        grant: ['READ'],
        where: '_status.ID > 2'
    },
    {
        grant: ['*'],
        where: '_status.ID < 3'
    }
]);

annotate OrderLines with {
    quantity @title: 'Quantity';
};

annotate Articles with {
    name @title: 'Article Name';
    price @title: 'Price';
    currency @title: 'Currency';
    maxRebate @title: 'Max. Rebate';
    remainingStock @title: 'Remaining Stock';
}
