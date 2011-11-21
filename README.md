Amazon SDB
==========
This is a simple interface to the Amazon Web Services product called SimpleDB.  SimpleDB is a key-value store that can be accessed via http requests.

Changes by BarrettJ
--------------------
* Now responds via a block instead of a delegate.
* Easier to support multiple logins [(]SDB setAccessKey:andSecretKey:]
* Times out after a pre-defined number of seconds
* Can now put multi-value attributes [SDB putMultiItem...]
* Can now get/select multi-value attributes - see the addional select and get with the readMultiValue:(BOOL) parameter
* Now supports NextToken on select statements (see [SDB continueOperation:block:];)
* Attribute Values are now automatically URL Encoded
* Returns errors given by SimpleDB

Supported Operations
--------------------
A full list of SDB Operations (queries) can be found here:
http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuide/index.html?SDB_API.html
Currently, the following of these are implemented: (Covers the full domain as of 11/17/2011)

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
* Paging/NextToken handling - Check!
* Support multiple Item.Attribute values - Check!
* Handle exceptions (No network, etc.) - Currently done via timeout (more or less Check!)
* Provide better parsing of SDB error messages - Check!
* Input validation
* Build out full example application
