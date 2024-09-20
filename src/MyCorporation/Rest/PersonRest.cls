Class MyCorporation.Rest.PersonRest Extends %CSP.REST
{

Parameter VERSION = 1.0;

XData UrlMap [ XMLNamespace = "https://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/" Method="HEAD" Call="Ping" />
    <Route Url="/" Method="GET" Call="GetAllPersons" />
    <Route Url="/:id" Method="GET" Call="GetPerson" />
    <Route Url="/" Method="POST" Call="CreatePerson" />
    <Route Url="/:id" Method="PUT" Call="UpdatePerson" />
    <Route Url="/:id" Method="DELETE" Call="DeletePerson" />
    <Route Url="/populate/:amount" Method="GET" Call="Populate" />
</Routes>
}

ClassMethod Populate(amount As %Integer) As %Status
{
    return ##class(MyCorporation.Service.PersonService).Populate(amount)
}

ClassMethod Ping() As %Status
{
    set %response.ContentType = ..#CONTENTTYPEJSON
    set %response.Status = ..#HTTP200OK
   
    Quit $$$OK
}

ClassMethod CreatePerson() As %Status
{
    set dto = %request.Content

    set person = ##class(MyCorporation.Rest.PersonMapper).FromJSON(dto)
    set sc = person.%Save()
    if 'sc
    {
        set %response.Status = ..#HTTP400BADREQUEST
        set %response.ContentType = ..#CONTENTTYPEJSON
        write { "message": "Error on save person" }.%ToJSON()
    
        Quit $$$OK
    }   

    set json = ##class(MyCorporation.Rest.PersonMapper).ObjectToJSON(person)

    set %response.Status = ..#HTTP200OK
    set %response.ContentType = ..#CONTENTTYPEJSON
    write json.%ToJSON()

    Quit $$$OK
}

ClassMethod UpdatePerson(id As %Integer) As %Status
{
    set content = %request.Content
    set dto = {}.%FromJSON(content)

    set person = ##class(MyCorporation.Service.PersonService).FindById(id)
    if '$ISOBJECT(person) {
        set %response.ContentType = ..#CONTENTTYPEJSON
        set %response.Status = ..#HTTP404NOTFOUND
        write { "message": "Person not found" }.%ToJSON()
       
        Quit $$$OK
    }

    set person.Name = dto.%Get("name")
    set person.DOB = $ZDH(dto.%Get("dob"),3)
    set person.SSN = dto.%Get("ssn")

    set sc = person.%Save()
    if 'sc
    {
        set %response.ContentType = ..#CONTENTTYPEJSON
        set %response.Status = ..#HTTP400BADREQUEST
        write { "message": "Error on save person" }.%ToJSON()
        
        Quit $$$OK
    }

    set %response.Status = ..#HTTP204NOCONTENT
    
    Quit $$$OK
}

ClassMethod DeletePerson(id As %Integer) As %Status
{
    set person = ##class(MyCorporation.Service.PersonService).FindById(id)
    if '$ISOBJECT(person) {
        set %response.Status = ..#HTTP404NOTFOUND
        set %response.ContentType = ..#CONTENTTYPEJSON
        write { "message": "Person not found" }.%ToJSON()
        Quit $$$OK
    }

    set sc = person.%DeleteId(id)
    if 'sc
    {
        set %response.Status = ..#HTTP400BADREQUEST
        set %response.ContentType = ..#CONTENTTYPEJSON
        write { "message": "Error on delete person" }.%ToJSON()
        Quit $$$OK
    }

    set %response.Status = ..#HTTP204NOCONTENT

    Quit $$$OK
}

ClassMethod GetPerson(id As %Integer) As %Status
{
    set person = ##class(MyCorporation.Service.PersonService).GetPerson(id)

    if '$ISOBJECT(person) {
        set %response.Status = ..#HTTP404NOTFOUND
        set %response.ContentType = ..#CONTENTTYPEJSON
        write { "message": "Person not found" }.%ToJSON()

        Quit $$$OK
    }

    set json = ##class(MyCorporation.Rest.PersonMapper).ObjectToJSON(person)

    set %response.Status = ..#HTTP200OK
    set %response.ContentType = ..#CONTENTTYPEJSON
    write json.%ToJSON()

    Quit $$$OK
}

ClassMethod GetAllPersons() As %Status
{
    Set persons = []
    Set rs = ##class(MyCorporation.Service.PersonService).GetAllPersons()
    
    While rs.%Next()
    {
        Set person = ##class(MyCorporation.Rest.PersonMapper).StatementResultToJSON(rs)
        Do persons.%Push(person)
    }

    set %response.Status = ..#HTTP200OK
    set %response.ContentType = ..#CONTENTTYPEJSON
    write persons.%ToJSON()

    Quit $$$OK
}

}
