#!/usr/bin/env nextflow

// simplecode to provide basic functionality  

process sayHello {

    publishDir 'results',  mode: 'copy'

    input:
        val greeting

    output:
        path "${greeting}-output.txt"

    script:
    """
    echo 'Hello World!' > '${greeting}-output.txt'
    """
}
// params.greeting_ch = "hello"
params.greeting_ch = "greeting.csv"

workflow {

    // ARRAY APPROACH 
    // greeting_array = ['Hola', 'Ahoj']
    // greeting_ch = Channel.of(greeting_array).flatten()
    // sayHello(greeting_ch)

    // DIRRECT INPUT
    // greeting_ch = Channel.of('Hello')
    // sayHello(greeting_ch)


    // sayHello(params.greeting_ch)

    greeting_ch = Channel.fromPath(params.greeting_ch)
                            .splitCsv()
                            .map{ item -> item[0] }
    sayHello(greeting_ch)
}