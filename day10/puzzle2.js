#!/usr/bin/env node

import fs from 'node:fs'

const printMap = map => {
    map.forEach(row => console.log(row.join(' ')))
}

const printTrailheads = map => {
    map.forEach(row => console.log(row.map(cell => cell ? '.' : '0').join(' ')))
}

const valid = (map, coord) => 0 <= coord[0] && coord[0] < map.length && 0 <= coord[1] && coord[1] < map[0].length

const hike = (map, coord) => {
    if (map[coord[0]][coord[1]] == 9) {
        return [ coord ]
    }

    return [
        [ coord[0] - 1, coord[1]     ],
        [ coord[0]    , coord[1] + 1 ],
        [ coord[0] + 1, coord[1]     ],
        [ coord[0]    , coord[1] - 1 ],
    ]
        .filter(c => valid(map, c))
        .filter(c => map[c[0]][c[1]] == map[coord[0]][coord[1]] + 1)
        .map(c => hike(map, c))
        .flat()
}

fs.readFile('sample.txt', 'utf8', (err, data) => {
    if (err) {
        console.error(err)
        return
    }

    const lines = data.split('\n').filter(s => s !== '')
    console.log('lines')
    console.log(lines)
    console.log()

    const map = lines.map(line => line.split('').map(c => parseInt(c, 10)))
    console.log('map:')
    printMap(map)
    console.log()

    const trailheads =
          map.map((row, x) =>
              row.map((cell, y) =>
                  cell ? null : [x, y]
              ).filter(coord => coord)
          ).flat()
    
    console.log('trailheads:')
    printTrailheads(map)
    trailheads.forEach(coord => console.log(coord))
    console.log()

    const ratings = trailheads.map(trailhead => hike(map, trailhead).length)
    console.log('Ratings')
    console.log(ratings)
    console.log()

    const total = ratings.reduce((acc, rating) => acc + rating, 0)
    console.log(`Total: ${total}`)
})
