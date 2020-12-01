/**
 * Created by Lara on 02/11/2014.
 */
var callback = function(){
    $('.item-skills').each(function(){
        newWidth = $(this).parent().width() * $(this).data('percent');
        $(this).width(0);
        $(this).animate({
            width: newWidth,
        }, 1000);
    });
    $('.icons-red').each(function(){
        height = $(this).height();
        $(this).animate({
            height: 14,
        }, 2000);
    });
};
$(document).ready(callback);

var resize;
window.onresize = function() {
    clearTimeout(resize);
    resize = setTimeout(function(){
        callback();
    }, 100);
};

$( "#skill_es" ).hover(
    function() {
        $( this ).append( $( "<span id=\"mcer\">Mother tongue</span>" ) );
    }, function() {
        $( this ).find( "span:last" ).remove();
    }
);

$( "#skill_en" ).hover(
    function() {
        $( this ).append( $( "<span id=\"mcer\">C1 Level  (<a href=\"http://en.wikipedia.org/wiki/Common_European_Framework_of_Reference_for_Languages\">CEFR</a>)</span>" ) );
    }, function() {
        $( this ).find( "span:last" ).remove();
    }
);

$( "#skill_ar" ).hover(
    function() {
        $( this ).append( $( "<span id=\"mcer\">A1 Level  (<a href=\"http://en.wikipedia.org/wiki/Common_European_Framework_of_Reference_for_Languages\">CEFR</a>)</span>" ) );
    }, function() {
        $( this ).find( "span:last" ).remove();
    }
);

$( "skill.fade" ).hover(function() {
    $( this ).fadeOut( 100 );
    $( this ).fadeIn( 500 );
});