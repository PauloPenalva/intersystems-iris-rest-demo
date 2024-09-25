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
    Quit ##class(MyCorporation.Service.PersonService).Populate(amount)
}

ClassMethod Ping() As %Status
{
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Status = ..#HTTP200OK

    Quit $$$OK
}

ClassMethod CreatePerson() As %Status
{
    #dim ex As %Exception.SystemException

    Try
    {
        Set dto = %request.Content
        Set person = ##class(MyCorporation.Rest.PersonMapper).FromJSON(dto)

        Do ##class(MyCorporation.Service.PersonService).CreatePerson(person)

        Set json = ##class(MyCorporation.Rest.PersonMapper).ObjectToJSON(person)

        Set %response.Status = ..#HTTP200OK
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Write json.%ToJSON()
    }
    Catch ex
    {
        Set %response.Status = ..#HTTP400BADREQUEST
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Set error = {}
        Do error.%Set("code", ex.Code)
        Do error.%Set("name", ex.Name)
        Do error.%Set("location", ex.Location)
        Do error.%Set("data", ex.Data)

        Write error.%ToJSON()
    }

    Quit $$$OK
}

ClassMethod UpdatePerson(id As %Integer) As %Status
{
    Set content = %request.Content
    Set dto = {}.%FromJSON(content)

    Set person = ##class(MyCorporation.Service.PersonService).FindById(id)
    If '$ISOBJECT(person)
    {
        Set %response.Status = ..#HTTP404NOTFOUND
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Write { "message": "Person not found" }.%ToJSON()
        Quit $$$OK
    }

     Try
     {
        Set person.Name = dto.%Get("name")
        Set person.DOB = $ZDATEH(dto.%Get("dob"),3)
        Set person.SSN = dto.%Get("ssn")
        Set sc = person.%Save()
        $$$ThrowOnError(sc)

        Set %response.Status = ..#HTTP204NOCONTENT
    }
    Catch ex
    {
        Set %response.Status = ..#HTTP400BADREQUEST
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Set error = {}
        Do error.%Set("code", ex.Code)
        Do error.%Set("name", ex.Name)
        Do error.%Set("location", ex.Location)
        Do error.%Set("data", ex.Data)

        Write error.%ToJSON()
    }

    Quit $$$OK
}

ClassMethod DeletePerson(id As %Integer) As %Status
{
    Set person = ##class(MyCorporation.Service.PersonService).FindById(id)
    If '$ISOBJECT(person)
    {
        Set %response.Status = ..#HTTP404NOTFOUND
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Write { "message": "Person not found" }.%ToJSON()
        Quit $$$OK
    }

    Set sc = person.%DeleteId(id)
    If 'sc
    {
        Set %response.Status = ..#HTTP400BADREQUEST
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Write { "message": "Error on delete person" }.%ToJSON()
        Quit $$$OK
    }

    Set %response.Status = ..#HTTP204NOCONTENT

    Quit $$$OK
}

ClassMethod GetPerson(id As %Integer) As %Status
{
    Set person = ##class(MyCorporation.Service.PersonService).GetPerson(id)

    If '$ISOBJECT(person)
    {
        Set %response.Status = ..#HTTP404NOTFOUND
        Set %response.ContentType = ..#CONTENTTYPEJSON
        Write { "message": "Person not found" }.%ToJSON()

        Quit $$$OK
    }

    Set json = ##class(MyCorporation.Rest.PersonMapper).ObjectToJSON(person)

    Set %response.Status = ..#HTTP200OK
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Write json.%ToJSON()

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

    Set %response.Status = ..#HTTP200OK
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Write persons.%ToJSON()

    Quit $$$OK
}

}
