var canvas;
var ctx;

var velocityX,velocityY;
var accelerationX,accelerationY;
var friction;
				// UP(0)   dwn(1)   left(2)   right(3)
var keyStatus = [false,false,false,false];
var UPKEY = 0, DOWNKEY = 1, LEFTKEY = 2, RIGHTKEY = 3;
var square=
{
	posx:10,
	posy:10,
	weight:30,
	dx:0,
	dy:0,
	render: function()
	{

		ctx.strokeStyle="red";
		ctx.fillStyle="blue";
		ctx.lineWidth=3;
		ctx.rect(this.posx,this.posy,this.weight,this.weight);
		ctx.fillRect(this.posx,this.posy,this.weight,this.weight);
		ctx.stroke();
	},

	update: function()
	{
		console.log(keyStatus);
		if(keyStatus[UPKEY] == true)
		{
			this.dy=-1;
		}
		if(keyStatus[DOWNKEY] == true)
		{
			this.dy=1;
		}
		else if(keyStatus[DOWNKEY]==false  && keyStatus[UPKEY] == false){
			this.dy=0;
		}

		if(keyStatus[LEFTKEY] == true)
		{
			this.dx=-1;
			console.log("dx is now : "+this.dx);
		}
		if(keyStatus[RIGHTKEY] == true)
		{
			this.dx=1;			
		}
		else if(keyStatus[RIGHTKEY] == false && keyStatus[LEFTKEY] == false)
		{
			this.dx=0;
		}

		console.log("dx is : "+this.dx+" dy is : "+this.dy);
		velocityX += accelerationX*this.dx;
		velocityY += accelerationY*this.dy;
		console.log("velocityX is : "+velocityX+" velocityY: "+velocityY);
		if(this.dx == 0 && this.dy == 0)
		{
			console.log("both zero");
			velocityX = velocityX*friction;
			velocityY = velocityY*friction;
		}
		this.posx = this.posx + velocityX;//this.dx;
		this.posy = this.posy + velocityY;//*this.dy;
	}

};
function simulate()
{
	canvasClear();
	square.update();
	square.render();	
}
function canvasClear()
{
	ctx.beginPath();
	ctx.fillStyle="black";
	ctx.fillRect(0,0,500,500);
	ctx.stroke();
}
function main()
{
	accelerationX = 0.5;
	accelerationY = 0.5;
	velocityX = 0;
	velocityY = 0;
	friction=0.9;
	console.log("main called");
	canvas = document.getElementById('myCanvas');
	ctx = canvas.getContext('2d');
	document.addEventListener('keydown', function(event)
	{
		if(event.keyCode == 37){
			keyStatus[LEFTKEY]=true;
			console.log("left key");

		}
		else if(event.keyCode == 39){
			keyStatus[RIGHTKEY] = true;
			console.log("right key");

		}
		else if(event.keyCode==40){
			keyStatus[DOWNKEY] = true;
			console.log("down key");
		}
		else if(event.keyCode==38){
			keyStatus[UPKEY] = true;
			console.log("up key");
		}
	});
	document.addEventListener('keyup', function(event)
	{
		if(event.keyCode == 37){
			keyStatus[LEFTKEY]=false;
		}
		else if(event.keyCode == 39){
			keyStatus[RIGHTKEY] = false;
		}
		else if(event.keyCode==40){
			keyStatus[DOWNKEY] = false;
		}
		else if(event.keyCode==38){
			keyStatus[UPKEY] = false;
		}
	});
	window.setInterval(simulate,21);
}
window.onload = main;