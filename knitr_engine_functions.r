knitr_engine_functions <- function (options) 
{
    engine = options$engine
    code = if (engine %in% c("highlight", "Rscript", "sas", "haskell", 
                             "stata",  "matlab")) {
        f = basename(tempfile(engine, ".", switch(engine, sas = ".sas", 
                                                  Rscript = ".R", stata = ".do", matlab = ".m",".txt")))   
        if  (engine %in% c("matlab"))
        {
             f = paste( substr(f,0,10),".m",sep="")
        }
        writeLines(c(switch(engine, 
                            sas = "OPTIONS NONUMBER NODATE PAGESIZE = MAX FORMCHAR = '|----|+|---+=|-/<>*' FORMDLIM=' ';title;", 
                            haskell = ":set +m"), 
                     options$code), 
                   f)
        #if (! (engine %in% c("matlab"))) 
            on.exit(unlink(f))
        switch(engine, 
               haskell = paste("-e", shQuote(paste(":script", f))), 
               sas    = {
                   logf = sub("[.]sas$", ".lst", f)
                   on.exit(unlink(c(logf, sub("[.]sas$", ".log", f))), add = TRUE)
                   f }, 
               stata  = {
                   logf = paste( getwd(),"/", sub("[.]do$", ".log", f),sep='')
                   on.exit(unlink(c(logf)), add = TRUE)
                   paste(ifelse(.Platform$OS.type == "windows", "/q /e do", 
                                "-q -b"), paste(getwd(),"/", f,sep=''))}, 
               matlab = {
                   logf = paste( getwd(),"/", sub("[.]m$", ".txt", f),sep='')
                   on.exit(unlink(logf), add = TRUE)
                   fkaal = sub("[.]m$", "", f)
                   Sys.sleep(1)
                   paste(" -logfile \"", logf, "\" -r \" cd('",getwd(),"');",fkaal, ";  quit\"",sep='')
               }, 
               f)
    }
    else paste(switch(engine, bash = "-c", coffee = "-e", groovy = "-e", 
                      lein = "exec -e", node = "-e", perl = "-e", python = "-c", 
                      ruby = "-e", scala = "-e", sh = "-c", zsh = "-c", NULL), 
               shQuote(paste(options$code, collapse = "\n")))
    code = if (engine %in% c("awk", "gawk", "sed", "sas", "matlab")) 
        paste(code, options$engine.opts)
    else paste(options$engine.opts, code)
    cmd = options$engine.path # %n% engine
    out = if (options$eval) {
        message("running: ", cmd, " ", code)
        tryCatch(system2(cmd, code, stdout = TRUE, stderr = TRUE), 
                 error = function(e) {
                     message("Error in running command", cmd)
                     if (!options$error) 
                         stop(e)
                 })
    }
    else ""
    if (!options$error && !is.null(attr(out, "status"))) 
    {   #message("HOQC1 ",out)
        stop(paste(out, collapse = "\n"))
    }
    
    if (options$eval && engine %in% c("matlab"))
        Sys.sleep(options$waittime)
    if (options$eval && engine %in% c("sas", "stata", "matlab") && file.exists(logf)) 
    {   
        loglines = readLines(logf, n=2000)
        
        if (engine %in% c("matlab")) 
            loglines = tail(loglines,-5)   
        out = c(loglines, out) 
    }
    #else #message("HOQC4 ",logf)
    engine_output(options, options$code, out)
}