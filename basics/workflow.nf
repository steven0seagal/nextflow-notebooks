#!/usr/bin/env nextflow

/*
 * Use echo to print 'Hello World!' to a file
 */
process sayHello {

    publishDir 'results', mode: 'copy'

    input:
        val greeting

    output:
        path "${greeting}-output.txt"

    script:
    """
    echo '$greeting' > '$greeting-output.txt'
    """
}

process convertToUpper {

    publishDir 'results', mode: 'copy'

    input:
        path input_file

    output:
        path "UPPER-${input_file}"

    script:
    """
    cat '$input_file' | tr '[a-z]' '[A-Z]' > 'UPPER-${input_file}'
    """
}

process collectGreetings {

    publishDir 'results', mode: 'copy'

    input:
        path input_files

    output:
        path "COLLECTED-output.txt"

    script:
    """
    cat ${input_files}  > 'COLLECTED-output.txt'
    """
}


/*
 * Pipeline parameters
 */
params.greeting = 'greeting.csv'

workflow {

    // create a channel for inputs from a CSV file
    greeting_ch = Channel.fromPath(params.greeting)
                        .splitCsv()
                        .map { line -> line[0] }

    // emit a greeting
    sayHello(greeting_ch)

    convertToUpper(sayHello.out)

    collectGreetings(convertToUpper.out.collect())
}