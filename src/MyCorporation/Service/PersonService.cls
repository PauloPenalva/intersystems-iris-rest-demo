Class MyCorporation.Service.PersonService Extends %RegisteredObject
{

ClassMethod Populate(amount As %Integer = 100) As %Status
{
       
        do ##class(MyCorporation.Data.Person).%DeleteExtent()
        do ##class(MyCorporation.Data.Person).Populate(amount)

        return $$$OK
}

ClassMethod CreatePerson(person As MyCorporation.Data.Person) As %Status
{
        return person.%Save()
}

ClassMethod FindById(id As %Integer) As MyCorporation.Data.Person
{
        return ##class(MyCorporation.Data.Person).%OpenId(id)
}

ClassMethod GetAllPersons() As %SQL.StatementResult
{
        return ##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM MyCorporation_Data.Person")
}

ClassMethod GetPerson(id As %Integer) As MyCorporation.Data.Person
{
        return ##class(MyCorporation.Data.Person).%OpenId(id)
}

ClassMethod ListData()
{
        set rs=##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM MyCorporation_Data.Person")
        while rs.%Next() {
                write !,$ZCONVERT(rs.%Get("Name"),"U"), " "
                write $ZDATE(rs.%Get("DOB"),4)," "
                write rs.%Get("SSN")
        }
}

}
