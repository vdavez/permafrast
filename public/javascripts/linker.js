document.addEventListener("DOMContentLoaded", function() {
  var citationToPFLink = function(citation) {
    if (citation.type == "reporter") {
      var url = "https://permafrast.herokuapp.com/" + citation.reporter.volume + "/" + citation.reporter.reporter + "/" + citation.reporter.page;
      return "<a class='citation' href='" + url + "'>" + citation.match + "</a>";
    };
  };
  
  var thePage = $('div#fetched_page');
  var doc = document.getElementById('fetched_page');
  // find the citations
  var citations = Citation.find(doc.innerHTML).citations;
              
  // loop through each citation
  for (i = 0; i < citations.length; i++) {
    if (citations[i].type == "reporter") {
      // generate a link
      var link = citationToPFLink(citations[i]);
      // stick the link onto the DOM
      thePage.html(thePage.html().replace(citations[i].match, link)); 
    } 
  }
});
