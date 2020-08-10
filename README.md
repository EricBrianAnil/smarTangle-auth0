# smarTangle Warehouse Management System | Team hackOverflow | Auth0
A **Tangle** network based SaaS Warehouse Optimization System for a Food Warehouse that covers tracking of the movement, quality and shelf life of the product and also predicts the requirement of raw materials  based on daily demands for a long period using the **FbProphet** Time Series forecasting model. The project consists of a **Django-based web application** as well as a **Flutter based mobile application.**
### [Check out the Project demo video here!](https://youtu.be/LEVnECEvn_U)

[**Check Our Website out here :)**](http://34.66.58.127/)

![](/Images/poster1.png)

# Technical Stack & Architectural Flow 
![](/Images/Architectural-Flow.png)
The technological stack that has been used for the component-wise design and implementation of this  project as a reference to the working architecture flow are as follows:

* **Machine Learning Model :**
   * [TensorFlow Keras API](https://www.tensorflow.org/)
   * [FbProphet Model by Facebook](https://facebook.github.io/prophet/docs/quick_start.html) *(Time Series Model)*
   * [TPOT Regressor](https://epistasislab.github.io/tpot/) *(Quality Score Prediction)*
    
* **Tangle Network:**
  * [IOTA Comnet (public) Tangle Network](https://comnet.thetangle.org/)
  > For more information regarding the tangle network, visit [https://www.iota.org/](https://www.iota.org/)

* **Warehouse-End Web Application :**
  * [Django Framework](https://www.djangoproject.com/) *(Back-End)*
  * [HTML](https://developer.mozilla.org/en-US/docs/Web/HTML), [CSS](https://developer.mozilla.org/en-US/docs/Web/CSS), [JS](https://developer.mozilla.org/en-US/docs/Web/JavaScript), [Bootstrap](https://getbootstrap.com/)  *(Front-End)*
  * [Google Cloud](https://console.cloud.google.com/) *(Deployment)*
  * [Google Compute Engine](https://cloud.google.com/compute) *(Deployment)*
  * [Auth0 Login](https://auth0.com/) *(Login Provider)*
  
* **Customer-End Mobile Application :**
  * [Flutter](https://flutter.dev/) *(Android Development SDK using Dart)*
  * [Google Maps SDK](https://developers.google.com/maps/documentation/android-sdk/intro) *(Maps and Location details)*
  
* **Databases:**
  * [Influx DB](https://www.influxdata.com/) from IBM Cloud Catalog *(Processing of ML data)*
  * [Firebase](https://firebase.google.com/) *(NoSQL : User data & Requests  from the mobile application)*
  * [SQLite](https://www.sqlite.org/index.html) *(SQL : Store Inventory & Raw Material information)*


# What Does It Do?
In a nutshell, our solution proposal - smarTangle  is a novel system which integrates the use of the **IOTA based Tangle network** to set its base as a Warehouse Optimization and Management system for a food warehouse that produces raw materials. It consists of a **Django based web application** for the usage of the warehouse alongside a **Flutter based mobile application** for the customers. The web app extensively works to forecast the raw material requirements of its subsidiary stores in a span of over 10 weeks , which helps prioritize the warehouse inventory of raw materials to prevent food wastage and reduce food insecurity. On the other hand the mobile app wraps this system by providing crucial information regarding the raw materials and its journey securely till it has reached the customer so as to increase the authenticity of the food network while working to reduce the effects of panic buying.

![](/Images/Web-404.png)

<p align="center">A project by Team hackOverflow.</p>
