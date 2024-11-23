using {OrdersService as service} from '../srv/orders-service';


annotate service.Orders with @(UI: {

    HeaderInfo                     : {
        TypeName      : 'Order',
        TypeNamePlural: 'Orders'
    },
    // Annotate the order table
    LineItem                       : [
        {Value: orderNumber},
        {Value: _status_ID, },
        {Value: expectedDeliveryDate}
    ],


    SelectionFields                : [_status_ID],
    TextArrangement                : #TextFirst,


    HeaderFacets                   : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Order Information',
        ID    : 'orderInfo',
        Target: '@UI.FieldGroup#OrderInfo'
    }, ],

    Facets                         : [{
        $Type : 'UI.ReferenceFacet',
        Label : '{@i18n>@GeneralInfoFacetLabel}',
        Target: '_orderLines/@UI.LineItem',
    },

    ],


    FieldGroup #OrderInfo          : {
        $Type: 'UI.FieldGroupType',
        Label: 'Order Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: orderNumber
            },
            {
                $Type: 'UI.DataField',
                Value: orderDate
            },
            {
                $Type: 'UI.DataField',
                Value: _status_ID
            },
            {
                $Type: 'UI.DataField',
                Value: expectedDeliveryDate
            },
            {
                $Type: 'UI.DataField',
                Value: orderDate
            },
        ]
    },

    DataPoint #ExpectedDeliveryDate: {
        Value: expectedDeliveryDate,
        Title: 'Expected Delivery Date',
    }


});


annotate service.OrderItems with @(UI: {
    LineItem             : [
        {Value: article.name},
        {Value: article.price},
        {Value: quantity},
        {Value: lineTotal}
        

    ],

    Facets               : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Order Line',
        ID    : 'orderLine',
        Target: '@UI.FieldGroup#OrderLine'
    }, ],

    FieldGroup #OrderLine: {
        $Type: 'UI.FieldGroupType',
        Label: 'Order Line',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: article.name
            },
            {
                $Type: 'UI.DataField',
                Value: article.price,
            },
            {
                $Type: 'UI.DataField',
                Value: quantity
            }

        ]
    },
    


}, Aggregation : { 
    ApplySupported: {
    GroupableProperties: [
      order_ID
    ]
  },
  CustomAggregate #quantity: 'Edm.Int32'
 }
 
) ;



annotate service.Articles with @(UI: {

HeaderInfo: {
    TypeName      : 'Article',
    TypeNamePlural: 'Articles'
}},

LineItem: [
    {Value: name},
    {Value: price},
    {Value: description}
]
)
{
    price @Analytics.Measure @Aggregation.default: #SUM
};
