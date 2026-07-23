 locals  {
    ecr = {
        cms_api         = {
            tag         = "6.0.48-con3"
        },
        cms_auth        = {
            tag         = "6.0.48-con3"
        },
        frontend        = {
            tag         = "latest"
        },
        concurrency     = {
            tag         = "6.0.48-con3"
        },
        edithistory     = {
            tag         = "6.0.48-con3"
        },
        permission      = {
            tag         = "6.0.48-con3"
        },
        agents          = {
            tag         = "latest"
        },
        mailer          = {
            tag         = "6.0.48-con3"
        },
        mongo           = {
            url         = "mongo"
            tag         = "4.2-bionic"
        },
        tsv_exporter    = {
            tag         = "6.0.48-con3"
        },
        dmm_api         = {
            tag         = "6.0.25"
        },
        filemanagement  = {
            tag         = "6.0.48-con3"
        },
        react           = {
            url         = ""
            tag         = ""
        },
        dmm_agents     = {
            url         = ""
            tag         = ""
        },
    }
 }
