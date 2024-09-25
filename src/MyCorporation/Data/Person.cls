Class MyCorporation.Data.Person Extends (%Persistent, %Populate)
{

Property Name As %String [ Required ];

Property DOB As %Date;

Property Age As %Integer;

Property SSN As %String;

Index NameIndex On Name;

Index SSNIndex On SSN [ Unique ];

Property NameUpperCase As %String [ Calculated, SqlComputeCode = { Set {*} = $ZCONVERT({Name}, "U") }, SqlComputed ];

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>DOB</Value>
</Value>
<Value name="4">
<Value>Age</Value>
</Value>
<Value name="5">
<Value>SSN</Value>
</Value>
</Data>
<DataLocation>^MyCorporation.Data.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<IdLocation>^MyCorporation.Data.PersonD</IdLocation>
<IndexLocation>^MyCorporation.Data.PersonI</IndexLocation>
<StreamLocation>^MyCorporation.Data.PersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
