<!-- 
<?php include_once("Galertssept-index.html"); ?>
<?php include_once("Galertsoct-index.html"); ?> -->

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

    <title>LDAvis</title>
  </head>

  <body>

  <div class="w3-container">
  <h2>Visualizations</h2>
  <p>LDavis visualizations for CORD and Google Alerts</p>

  <!-- <?php include_once("Galertssept-index.html"); ?>
  <?php include_once("Galertsoct-index.html"); ?>
 -->
  <div class="w3-bar w3-black">
    <button class="w3-bar-item w3-button tablink w3-red" onclick="openCity(event,'London')">London</button>
    
    <button class="w3-bar-item w3-button tablink" onclick="openCity(event,'Sept')">Sept</button>
    
    <button class="w3-bar-item w3-button tablink" onclick="openCity(event,'Oct')">Oct</button>
  </div>
  
  <div id="London" class="w3-container w3-border city">
    <h2></h2>
    <p>London is the capital city of England.</p>
  </div>

  <div id="Sept" class="w3-container w3-border city" style="display:none">
    <h2>Sept</h2>
    <?php include("Galertssept-index.html"); ?>
  </div>

  <div id="Oct" class="w3-container w3-border city" style="display:none">
    <h2>Oct</h2>
    <?php include("Galertsoct-index.html"); ?>

  </div>
</div>

</body>

</html>

<!-- ----------------------------

  <h1>BREAKING</h1>>

  <div class="w3-bar w3-light-grey">
    
    <a href="#0"style="text-decoration:none" class="w3-bar-item w3-button tablink w3-blue">Test</a>

    <a href="Galertsoct-index.html"style="text-decoration:none" class="w3-bar-item w3-button tablink ">Oct</a>

    <a href="#0"style="text-decoration:none" class="w3-bar-item w3-button tablink">Idk</a>

  </div>
</div>
  

<script>
function openCity(evt, cityName) {
  var i, x, tablinks;
  x = document.getElementsByClassName("city");
  for (i = 0; i < x.length; i++) {
    x[i].style.display = "none";
  }
  tablinks = document.getElementsByClassName("tablink");
  for (i = 0; i < x.length; i++) {
    tablinks[i].className = tablinks[i].className.replace(" w3-red", "");
  }
  document.getElementById(cityName).style.display = "block";
  evt.currentTarget.className += " w3-red";
}
</script>

  
  </div>    
    <script>
      var vis = new LDAvis("#lda", "lda.json");
    </script>
  </div>

  <div id = "lda3"></div>
    <script>
      var vis = new LDAvis("#lda3", "Galertsoct-lda.json");
  </script>

  </body>

</html>
 -->