# NetSherlock
Flutter app for Shodan 

NetSherlock is a dynamic network monitoring app that utilizes the Shodan API to provide real-time insights into connected devices, open ports, and potential vulnerabilities. 
Additionally, it performs basic DNS lookups to offer essential information about domain names and IP addresses. 
With a user-friendly interface and customizable alerts, NetSherlock empowers users to proactively manage and secure their networks effectively.

```
lib
├───models => speaks for itself, contains our models, which are our entities fetched from the Shodan API or pushed to the said API
├───pages => contains our different pages, all of which are access through named routes
├───providers => contains one single provider that allows to interact with the Shodan API
├───services => our different services for state management. 
└───widgets => all of our component-widgets used in different parts of our pages. contains a mix of stateful and stateless widgets
```

For state management, it mostly revolved around the Provider Library; the API provides some streaming endpoints, but they havent been used, due to uh some lack of time. 

## Setup and build

Nothing special is required to build the android app.
However it may take some time to download all libraries n stuff because the QR-reading one needs to download a Google-based ML model first. 