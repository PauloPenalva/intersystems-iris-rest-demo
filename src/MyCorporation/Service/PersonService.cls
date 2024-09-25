Class MyCorporation.Service.PersonService
{

ClassMethod Populate(amount As %Integer = 100) As %Status
{

    Do ##class(MyCorporation.Data.Person).%DeleteExtent()
    Do ##class(MyCorporation.Data.Person).Populate(amount)

    Return $$$OK
}

ClassMethod CreatePerson(person As MyCorporation.Data.Person) As %Status
{

    Try
    {
        Set sc = person.%Save()
        $$$ThrowOnError(sc)
    }
    Catch ex
    {
        Throw ex
    }
}

ClassMethod FindById(id As %Integer) As MyCorporation.Data.Person
{
    Return ##class(MyCorporation.Data.Person).%OpenId(id)
}

ClassMethod GetAllPersons() As %SQL.StatementResult
{
    Return ##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM MyCorporation_Data.Person")
}

ClassMethod GetPerson(id As %Integer) As MyCorporation.Data.Person
{
    Return ##class(MyCorporation.Data.Person).%OpenId(id)
}

ClassMethod ListData()
{
    Set rs=##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM MyCorporation_Data.Person")
    While rs.%Next()
    {
        Write !,$ZCONVERT(rs.%Get("Name"),"U"), " "
        Write $ZDATE(rs.%Get("DOB"),4)," "
        Write rs.%Get("SSN")
    }
}

ClassMethod PrintClassName()
{
    Set t=##class(MyCorporation.Data.Person).%New()

    Write !,"Class name: ",t.%ClassName()
    Write !,"Full Class name: ",t.%ClassName(1)
}

}
