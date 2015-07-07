var width = 450;
var x = d3.scale.linear()
.range([0, width]);


function callback (error, data) {
    x.domain([0, d3.max(data, function(d){
        return d[1];
    })])

    var bar = d3.select('.wordCounts')
    .selectAll('div')
    .data(data)
    .enter().append('div')

    var rec = bar.append('div')
    .transition()
    .duration(3000)
    .ease('cubic-out')
    .tween("text", function(d) {
        var i = d3.interpolateRound(0, d[1]);
        return function(t) {
            this.textContent = i(t);
        }
    })
    .style('width', function(d){return x(d[1]) + 'px'})

    var legend = bar.append('span').text(function (d) {
        return d[0]
    })
};

window.startDemo = function() {
    d3.select('.frontpage')
    .transition()
    .duration(1000)
    .style('opacity', '0')
    .style('top', '-75%')
    .each('end', function () {
        d3.select('.result')
        .classed('hide', false)
        .style('opacity', '0')
        .transition()
        .style('opacity', '1')
        d3.text('example/NotreDame.txt').get(function (error, data) {
            d3.json('http://localhost:3000/api/analyze?n=50')
            .post(data, callback)
        })
    });
}



Dropzone.options.myAwesomeDropzone = {
    clickable: false,
    maxFiles:1,
    acceptedFiles: ['.txt'],
    dictDefaultMessage: '',
    init: function() {
        this.on('maxfilesexceeded', function(file) {
            this.removeAllFiles();
            this.addFile(file);
        });

        this.on('dragenter', function () {
            d3.select('.frontpage')
                .classed('drag', true)
        })

        this.on('dragleave', function () {
            d3.select('.frontpage')
                .classed('drag', false)
        })

        this.on('sending', function () {
            d3.select('.frontpage')
                .remove()
        })
    },
};

