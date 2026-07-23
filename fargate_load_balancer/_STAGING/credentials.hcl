 locals  {
    database = {
        user = ""
        pass = ""
    }  

    mssql = {
        creds = ""
    }

    awsiam = {
        storageuser = {
            key     = ""
            secret  = ""
        },
        codedeploy  = {
            key     = ""
            secret  = ""
        },
        mibauth     = {
            key     = ""
            secret  = ""
        },
        assetimporter = {
            key     = ""
            secret  = ""
        },
        tsvexporter = {
            key     = ""
            secret  = ""
        },
        mailer      = {
            key     = ""
            secret  = ""
        }
    }
 }
