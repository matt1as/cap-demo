using {db as db} from '../db/orders';

service OrdersService {
    entity Orders     as projection on db.Orders {
        *,
        virtual false as statusReadOnly : Boolean
    };
    entity OrderItems as projection on db.OrderLines {
        *,
        virtual article.price * quantity as lineTotal : Decimal(15, 2)
    };
    entity Articles   as projection on db.Articles;
}

annotate OrdersService.Orders with @odata.draft.enabled;

annotate OrdersService.Articles with @odata.draft.enabled;
