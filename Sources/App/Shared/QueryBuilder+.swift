import FluentKit

extension QueryBuilder {

    func chain(_ exec: (QueryBuilder<Model>) -> QueryBuilder<Model>) -> QueryBuilder<Model> {
        
        exec(self)
    }

    func ifCond(_ predicate: @autoclosure () -> Bool, then: (QueryBuilder<Model>) -> QueryBuilder<Model>, otherwise: ((QueryBuilder<Model>) -> QueryBuilder<Model>)? = nil) -> QueryBuilder<Model> {

        if predicate() {
            return then(self)
        } else if let otherwise = otherwise {
            return otherwise(self)
        } else {
            return self
        }
    }

    func ifLet<V>(_ item: Optional<V>, then: (QueryBuilder<Model>, V) -> QueryBuilder<Model>, otherwise: ((QueryBuilder<Model>) -> QueryBuilder<Model>)? = nil) -> QueryBuilder<Model> {

        if let item = item {
            return then(self, item)
        } else if let otherwise = otherwise {
            return otherwise(self)
        } else {
            return self
        }
    }
}
