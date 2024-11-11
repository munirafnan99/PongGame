int keyScore, mouseScore; //keeps the tab of scores of the keyboard and the mouse
float cntX, cntY; //centre coordinates of the ball
float speedX = 3, speedY = 5; //speed of the ball
final int BALL_DIAM = 10; //diameter of the ball
float paddleSpeed = 8.0; //speed at which the paddle moves
final int MAX_SPEED = 3; //max speed of the ball
final int MIN_SPEED = 1; //min speed of the ball
final int PADDLE_LENGTH = 100;//length of the paddle
final int PADDLE_WIDTH = 10; //width of the paddle
float paddleLeftX, paddleLeftY, paddleRightX, paddleRightY; //variables controlling the movement of the ball
boolean upL, downL, upR, downR; //boolean values controlling the movement of the paddles
boolean gameOver = false; //boolean value controlling the end of the game when either of the sides reach the winning score of 11
float ballAngle = random ( PI/4, 3 * PI / 2 ); //angle at which ball moves
final float WIN_SCORE = 11; //winning score
final int INITIAL_SPEED_X = 3;

void setup() {
  size(600, 500);
  cntX = width/2;
  cntY = height/2;
  paddleLeftX = width/50;
  paddleLeftY = height/2 - PADDLE_LENGTH/2;
  paddleRightY = height/2 - PADDLE_LENGTH/2;
  paddleRightX = width - width/50 - PADDLE_WIDTH;
  speedX = INITIAL_SPEED_X * cos ( ballAngle );
}

void draw() {
  background(#0A2BA0); //blue
  drawGame();
  drawScore();
  movePaddle();
  paddleRestriction();
  moveBall();
  bounceY();
  bouncePaddle();
}

//writes the score every time one of the two players get a point
void drawScore() {
  textSize(20);
  String toPrint = "Keyboard: " + keyScore;
  text(toPrint, width/4 - textWidth( toPrint ) / 2, 50);
  toPrint = "Mouse: " + mouseScore;
  text(toPrint, width * 3/4 - textWidth( toPrint ) / 2, 50);
}

//draws every object in the game
void drawGame() {
  ellipse(cntX, cntY, BALL_DIAM, BALL_DIAM); //the ball
  rect(paddleLeftX, paddleLeftY, PADDLE_WIDTH, PADDLE_LENGTH); //left paddle
  rect(paddleRightX, paddleRightY, PADDLE_WIDTH, PADDLE_LENGTH); //right paddle
}

//controls the movement of the paddles
void movePaddle() {
  if (upL) {
    paddleLeftY = paddleLeftY - paddleSpeed; //move left paddle upwards
  }  
  if (downL) {
    paddleLeftY = paddleLeftY + paddleSpeed; //move left paddle downwards
  }  
  if (downR) {
    paddleRightY = paddleRightY + paddleSpeed; //move right paddle downwards
  }
  if (upR) {
    paddleRightY = paddleRightY - paddleSpeed; //move right paddle upwards
  }
  if (gameOver) {
    paddleSpeed = 0; //speed becomes zero when game is over and everything freezes
  }
}

//restricts the movement of the paddle as it reaches the top and the bottom of the screen
void paddleRestriction() { //paddle stops when it reaches the end points of the canvas

  if (paddleLeftY < 0) {  //when left paddle reaches the top
    paddleLeftY = paddleLeftY + paddleSpeed;
  }
  if (paddleLeftY + PADDLE_LENGTH > height) { //when left paddle reaches the bottom
    paddleLeftY = paddleLeftY - paddleSpeed;
  }
  if (paddleRightY < 0) { //when right paddle reaches the top
    paddleRightY = paddleRightY + paddleSpeed;
  }
  if (paddleRightY + PADDLE_LENGTH > height) { //when right paddle reaches the bottom
    paddleRightY = paddleRightY - paddleSpeed;
  }
}

//controls the movement of the ball at all times
void moveBall() {
  cntX =  cntX + speedX; //speed in the x-direction
  cntY =  cntY + speedY; //speed in the y-direction

  if (gameOver) { //when one of the players reach 11 points, the game will freeze as the ball stops moving and remains in the centre
    speedX = 0;
    speedY = 0;
  }
}

//controls the bouncing of the ball when it hits the top and bottom and when the scoring of the game when the ball goes off of the canvas from the left or right
void bounceY() {
  if ( cntY + BALL_DIAM/2 > height || cntY - BALL_DIAM/2 < 0 ) { //when ball reaches the top and bottom of the canvas, it bounces in the opposite direction
    speedY = speedY * -1;
  }
  if ( cntX + BALL_DIAM/2 > width) { //when ball goes beyond the canvas from the right side, then the game starts again and keyboard gets the point
    keyScore =  keyScore + 1;
    setup();
  }
  if ( cntX - BALL_DIAM/2 < 0 ) { //when ball goes beyond the canvas from the left side, then the game starts again and mouse gets the point
    mouseScore = mouseScore + 1;
    setup();
  }
  if ( keyScore == WIN_SCORE || mouseScore == WIN_SCORE) { //when the score reaches 11 for either side, which is the winning score, then the gameOver boolean becomes true
    gameOver = true;
  }
}

//controls the bouncing of the ball when it hits the paddles
void bouncePaddle() {  //when the ball touches either of the paddles, it bounces off of it

  if ( cntX - BALL_DIAM/2 < paddleLeftX + PADDLE_WIDTH && cntY - BALL_DIAM/2 > paddleLeftY && cntY + BALL_DIAM/2 < paddleLeftY + PADDLE_LENGTH) {
    if ( speedX < 0 ) {
      speedX = ((speedX - random (MIN_SPEED, MAX_SPEED)) * -1);
    }
  } else if ( cntX + BALL_DIAM/2 > paddleRightX && cntY + BALL_DIAM/2 < paddleRightY + PADDLE_LENGTH && cntY - BALL_DIAM/2 > paddleRightY ) {
    if ( speedX > 0 ) {
      speedX = ((speedX + random (MIN_SPEED, MAX_SPEED)) * -1);
    }
  }
}

//controls the movement of the paddle as long as the key is pressed
void keyPressed() {
  if (keyCode == UP || keyCode == 'W') { //when the upward arrow button is pressed, the left paddle moves up 
    upL = true;
  }
  if (keyCode == DOWN || keyCode == 'S') { //when the downward arrow button is pressed, the left paddle moves down
    downL = true;
  }
}

//controls the movement of the paddle as long as the mouse button is pressed
void mousePressed() {
  if (mouseButton == RIGHT) { //when the right mouse button is pressed, the right paddle moves down
    downR = true;
  }
  if (mouseButton == LEFT) { //when the left mouse button is pressed, the right paddle moves up
    upR = true;
  }
}

//controls the movement of the paddle the moment the key is released
void keyReleased() {
  if (keyCode == UP || keyCode == 'W') { //when the upward arrow button is released, the left paddle stops moving 
    upL = false;
  }
  if (keyCode == DOWN || keyCode == 'S') { //when the downward arrow button is released, the left paddle stops moving 
    downL = false;
  }
}

//controls the movement of the paddle the moment the mouse button is released
void mouseReleased() {
  if (mouseButton == RIGHT) { //when the right mouse button is released, the right paddle stops moving
    downR = false;
  }
  if (mouseButton == LEFT) { //when the left mouse button is released, the right paddle stop moving
    upR = false;
  }
}
