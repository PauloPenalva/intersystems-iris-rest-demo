Class MyCorporation.Rest.PersonMapper Extends %RegisteredObject
{

ClassMethod StatementResultToJSON(rs As %SQL.StatementResult) As %DynamicObject
{
        Set json = {}
        Do json.%Set("id", rs.%Get("ID"), "number")
        Do json.%Set("name", rs.%Get("Name"))
        Do json.%Set("dob", $ZDATE(rs.%Get("DOB"),3))
        Do json.%Set("ssn", rs.%Get("SSN"))
    
        Return json
}

ClassMethod ObjectToJSON(person As MyCorporation.Data.Person) As %DynamicObject
{
        Set json = {}
        Do json.%Set("id", person.%Id(), "number")
        Do json.%Set("name", person.Name)
        Do json.%Set("dob", $ZDATE(person.DOB,3))
        Do json.%Set("ssn", person.SSN)
    
        Return json
}

ClassMethod FromJSON(json As %String) As MyCorporation.Data.Person
{
        set dto = {}.%FromJSON(json)

        Set person = ##class(MyCorporation.Data.Person).%New()
        
        Set person.Name = dto.%Get("name")
        Set person.DOB = $ZDATEH(dto.%Get("dob"), 3)
        Set person.SSN = dto.%Get("ssn")   

        Return person
}

}
