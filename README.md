Amazon SDB
==========
This is a simple interface to the Amazon Web Services product called SimpleDB.  SimpleDB is a key-value store that can be accessed via http requests.

Changes by BarrettJ
--------------------
* Now responds via a block instead of a delegate.
* Easier to support multiple logins (SDB setAccessKey:andSecretKey:)

Supported Operations
--------------------
A full list of SDB Operations (queries) can be found here:
http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuideindex.html?SDB_API_Operations.html
Currently, the following of these are implemented: (Covers the full domain as of 8/14/2012)

* ListDomains
* DomainMetadata
* CreateDomain
* DeleteDomain
* Select
* GetAttributes
* PutAttributes
* DeleteAttributes
* BatchPutAttributes
* BatchDeleteAttributes

Installation
------------
* Requires Xcode 4.2 or greater (BETA version - lots of leaks without the ARC-enabled compiler)
* Call [SDB setAccessKey:ACCESS_KEY andSecretKey:SECRET_KEY] to set the key for an operation (and all subsequent operations)
* Edit the sdbExample methods in the AppDelegate to be appropriate in the context of your SDB account
* Build and run!

TODO
-----
* Paging/NextToken handling
* Support multiple Item.Attribute values
* Handle exceptions (No network, etc.)
* Provide better parsing of SDB error messages
* Input validation
* Build out full example application
