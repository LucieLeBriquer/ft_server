$(window).load(function(){
  function movePusheen(){
  $('#pusheen').animate({'left':"+=30%"},2000)
    .animate({'left':"-=30%"},2000,function(){
      movePusheen();
    });
  }
  movePusheen();
});

