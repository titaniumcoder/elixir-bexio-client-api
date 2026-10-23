# Search

Some older endpoints implement search methods. Searching for these endpoint works by sending a POST request to the resource (e.g.: POST `/contact/search` or POST `/country/search`).
The search parameters must be provided in the body of the POST request.
Please have a look at the resource documentation to see a list of available search parameters.
Criterias
You can use different criterias for the search. The criteria “like” will be used by default if you do not define a criteria.
Criteria
Description
`=`
Exact match
`equal`
Exact match (synonyme for =)
`!=`
Not equal
`not_equal`
Not equal (synonyme for !=)
`>`
Greather than
`greater_than`
Greather than (synonyme for >)
`
Less than
`less_than`
Less than (synonyme for
`>=`
Greater or equal then
`greater_equal`
Greater or equal then (synonyme for >=)
`
Lesser or equal then
`less_equal`
Lesser or equal then (synonyme for
`like`
Partial match
`not_like`
Does not partial match
`is_null`
Value is `NULL`
`not_null`
Value is not `NULL`
`in`
Having multiple results which matche, value must be an array e.g. `[1, 2]`
`not_in`
Having multiple results which do not match, value must be an array e.g. `[1, 2]`
Code example (PHP)
The following example shows how the search for the contacts API can be used.
The last name of the contact must be “Meyer” and the contact number must be greater than 10.
Define the search array
``$data = array(
array(
'field' => 'name_1',
'value' => 'Meyer',
'criteria' => '=',
),
array(
'field' => 'nr',
'value' => 10,
'criteria' => '>',
),
);
``
Transform the array to JSON
``json_encode($data);
``
POST-Body for the search
``[
{
"field" : "name_1",
"value" : "Meyer",
"criteria" : "="
},
{
"field" : "nr",
"value" : 10,
"criteria" : ">"
}
]
``
