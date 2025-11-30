#!/usr/bin/env node

import fs from 'node:fs'

// fs.readFile('sample1.txt', 'utf8', (err, data) => {
fs.readFile('input.txt', 'utf8', (err, data) => {
    if (err) {
        console.error(err)
        return
    }

    const lines = data.split('\n').filter(s => s !== '')
    console.log('lines')
    console.log(lines)
    console.log()

    const regex = /mul\((?<n1>\d{1,3}),(?<n2>\d{1,3})\)/g
    const multiplications = lines.map(line => [...line.matchAll(regex)].map(({groups: {n1, n2}}) => n1 * n2)).flat()
    console.log('multiplications:')
    console.log(multiplications)
    console.log()

    const total = multiplications.reduce((acc, term) => acc + term, 0)
    console.log(`Total: ${total}`)
})
