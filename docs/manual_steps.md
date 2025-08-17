# Vertex AI Search Widget

Quickly prototype and serve a Vertex AI Search app widget on a static website hosted on Google Cloud Storage (GCS).

> [!CAUTION]
> This guide is for demonstration purposes only. It is not intended for production use and does not provide any security or access control features.


<br>

## 🔍 Create a Search App and Data Store

> [!TIP]
> You can find additional public data in the [Vertex AI search samples bucket](https://console.cloud.google.com/storage/browser/cloud-samples-data/gen-app-builder/search)

1. Navigate to **AI Applications** → **Create app**
2. **App Type**: Select **Site search with AI mode** → **Create**
3. **App Configuration**: Select Enterprise and Generative features, add an app and company name, select `global` location → **Continue**
4. **App Data**: Click **Create Data Store**
5. **Data Store Source**: Select **Cloud Storage**
6. **Data Store Data**: Choose **Unstructured documents**, **One time sync**, select folder: `cloud-samples-data/gen-app-builder/search/alphabet-investor-pdfs` → **Continue**
7. **Data Store Configuration**: Name the data store, optionally select a different default document parser and settings → **Create**
8. Return to **App Data**: Select the GCS data store to connect to the app → **Create**


<br>

## 🪣 Create a GCS Bucket
1. Navigate to **Cloud Storage** → **Buckets** → **Create**
2. Name the bucket → **Continue**
3. Select the default location → **Continue**
4. Select the default storage class → **Continue**
5. **Do not** enforce Public access prevention (uncheck the box)
6. Set to uniform access control → **Continue**
7. Select the default data protection policy → **Create**


<br>

## 🔓 Set Public Bucket Permissions

> [!WARNING]
> Do not add sensitive data to this public bucket

1. Navigate to your **Bucket details** → **Permissions**
2. Click **Grant access** under the list of permissions
3. Add the `allUsers` principal and select the **Storage Object Viewer** (`roles/storage.objectViewer`) role → **Save**


<br>

## 🌐 Create an `index.html` File

> [!IMPORTANT]
> You must update the value of `configId` in the `gen-search-widget` element in the next step

```html
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vertex AI Search App</title>
    <style>
        body {
            font-family: sans-serif;
            padding: 20px;
        }

        h1,
        p {
            text-align: center;
        }
    </style>
</head>

<body>
    <h1>Vertex AI Search</h1>
    <p>Search your documents using the widget</p>

    <!-- Widget JavaScript bundle -->
    <script src="https://cloud.google.com/ai/gen-app-builder/client?hl=en_US"></script>

    <!-- Search widget element is not visible by default -->
    <gen-search-widget
        configId="replace-with-your-configId-value"
        triggerId="searchWidgetTrigger">
    </gen-search-widget>

    <!-- Element that opens the widget on click. It does not have to be an input -->
    <p>
        <button id="searchWidgetTrigger">Search Here</button>
    </p>
</body>

</html>
```


<br>

## ⚙️ Configure the Widget

> [!NOTE]
> Domain allowlist changes can take ~30 minutes to propagate

1. Navigate to the search app → **Integration** → **Widget**
2. Select **Public Access**
3. Add these allowed domains for the widget: 
    - `storage.googleapis.com` → **Add**
    - `localhost` → **Add**
    - Click **Save**

![Configure Acces](assets/alllowlist_domains.png)

4. Copy the `configId` value from the widget code and paste it inside double-quotes after `configId=` in the `index.html` file

![Copy configId](assets/copy_configId.png)

5. Navigate to the search app → **Configurations** → **UI** to configure additional widget attributes including generative answers or follow-ups
6. Test configurations in the **Test config** side pane to and click **Save and publish** to apply changes to the deployed widget

![Configure Answers](assets/configure_answers.png)


<br>

## 🚀 Deploy

> [!IMPORTANT]
> Use the name of your GCS bucket in place of `<your-bucket-name>` the URL

1. Upload the `index.html` file to the GCS bucket
2. Access the widget at `https://storage.googleapis.com/<your-bucket-name>/index.html`


<br>

## 📚 References

### Search App and Data Store
- [About apps and data stores](https://cloud.google.com/generative-ai-app-builder/docs/create-datastore-ingest)
- [Custom search checklist](https://cloud.google.com/generative-ai-app-builder/docs/generic-search-checklist)
- [Get started with custom search](https://cloud.google.com/generative-ai-app-builder/docs/try-enterprise-search#unstructured-data)
- [Create a search app](https://cloud.google.com/generative-ai-app-builder/docs/create-engine-es)
- [Create a search data store | Import from Cloud Storage](https://cloud.google.com/generative-ai-app-builder/docs/create-data-store-es#cloud-storage)
- [Parse and chunk documents](https://cloud.google.com/generative-ai-app-builder/docs/parse-chunk-documents)
- [Get search results](https://cloud.google.com/generative-ai-app-builder/docs/preview-search-results)
- [Get answers and follow-ups](https://cloud.google.com/generative-ai-app-builder/docs/answer)

### Cloud Storage
- [Create a bucket](https://cloud.google.com/storage/docs/creating-buckets)
- [Make data public](https://cloud.google.com/storage/docs/access-control/making-data-public#buckets)
- [Upload objects from a file system](https://cloud.google.com/storage/docs/uploading-objects)

### Widget Configuration
- [Add the search widget to a web page](https://cloud.google.com/generative-ai-app-builder/docs/add-widget)
- [Configure results for the search widget](https://cloud.google.com/generative-ai-app-builder/docs/configure-widget-attributes)
- [Public access problem in Gen App Builder integration](https://stackoverflow.com/questions/76975273/public-access-problem-in-gen-app-builder-integration)
