# Needles Conv Contact

| Script Name | Description | Dependencies |
|-------------|-------------|-------------|
| 1.00_std_UnidentifiedIndvContacts.sql | Create placeholder individual contacts used as fallback when contact records do not exist | [None] |
| 1.01_std_UnidentifiedOrgContacts.sql | Create placeholder organization contacts used as fallback when contact records do not exist | [None] |
| 1.02_std_Contacts.sql |  |  |
| 1.03_std_Insured.sql | Create contacts from needles..insurance | [None] |
| 1.04_std_PoliceOfficer.sql | No metadata found | No metadata found |
| 1.10_std_EmailWebsite.sql | update contact email addresses | [None] |
| 1.11_std_PhoneNumbers.sql | Update contact phone numbers | [None] |
| 1.92_std_Address.sql | Insert addresses | [None] |
| 1.93_std_Uniqueness.sql | None | [None] |
| 1.95_std_Comment.sql | None | [None] |
| 1.97_std_AllContactInfo.sql | Create sma_MST_AllContactInfo | [['sma_MST_AllContactInfo'], ['sma_MST_IndvContacts'], ['sma_MST_Address'], ['sma_MST_ContactNumbers'], ['sma_MST_EmailWebsite']] |
| 1.98_std_IndvOrgContacts.sql | None | ['sma_MST_AllContactInfo'] |
| 1.99_std_Notes.sql | No metadata found | No metadata found |
