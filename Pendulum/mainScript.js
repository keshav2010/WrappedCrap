var canvas,ctx;
var time;
var rod =
{
	weight:250,
	anchor_x:250,
	anchor_y:0,
	move_x:250,
	move_y:250,
	theta:0,
	dt:1,
	col:"red",
	render : function(){
		ctx.beginPath();
		ctx.strokeStyle="red";
		ctx.lineWidth=5;
		ctx.moveTo(250,0);
		ctx.lineTo(this.move_x,this.move_y);
		ctx.stroke();
	},
	update : function(){
		this.theta=this.theta + this.dt;
		console.log(this.theta);
		this.move_x = Math.floor(250+this.weight*Math.cos(this.theta*0.001));//*(180/Math.PI)
		this.move_y = 1+Math.floor(this.weight*Math.sin(this.theta*0.001));//(180/Math.PI)*
		console.log("move x : "+this.move_x + "and move_y = "+this.move_y);	
		if( this.move_x > 250 && this.move_y < 249)
		{
			this.dt = this.dt + 0.02;
		}
		else if( this.move_x < 250 && this.move_y <= 249 )
		{
			this.dt = this.dt - 0.02;
		}
	},
	simulate : function(){
		console.log("rod simulate call");
		this.render();
		this.update();
	}
};
var pendulum = {
	col:"yellow",
	weight:30,
	posx:rod.move_x-15,
	posy:rod.move_y-15,
	render : function(){
		ctx.beginPath();
		ctx.fillStyle=this.col;
		ctx.fillRect(this.posx,this.posy,this.weight,this.weight);
		ctx.stroke();
	},
	update : function(){ //pendulum
		this.posx=rod.move_x-15;
		this.posy=rod.move_y-15;
	},
	simulate:function() //pendulum
	{
		console.log("pendulum simulate call");
		pendulum.update();
		pendulum.render();

	}
}; //END OF PENDULUM
function simulate(){
	time = (time + 0.1);
	canvasClear();
	pendulum.simulate();
	rod.simulate();


}

function canvasClear()
{
	ctx.beginPath();
	ctx.fillStyle="black";
	ctx.fillRect(0,0,500,500);
	ctx.stroke();
}
function init()
{
	console.log("init");
	time=0;
	canvas = document.getElementById("myCanvas");
	ctx = canvas.getContext("2d");
	setInterval(simulate,.01);
}
window.onload = init;
