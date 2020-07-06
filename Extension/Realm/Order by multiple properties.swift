// https://stackoverflow.com/questions/27365809/order-by-multiple-properties-using-realm

let sortProperties = [SortDescriptor(property: "dateStart", ascending: true), SortDescriptor(property: "timeStart", ascending: true)]
allShowsByDate = Realm().objects(MyObjectType).sorted(sortProperties)
