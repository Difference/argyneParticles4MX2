'Example particles and factories for emitters
 

'Summary:  An implementation of a basic particle using a solid color.
Class SolidParticle Extends BaseParticle
	Field radius:Float
	Field blend:BlendMode  'Warning:  Probably use on glfw only
	Field r:Float = 1, g:Float = 1, b:Float = 1  'Color

	Field fadeIn:Int, fadeOut:Int 'lengths to fade in and out when rendering.
		
	Method New(ttl:int = 500, initialValues:ParticleValues = Null, finalValues:ParticleValues = Null)
		Super.New(ttl, initialValues, finalValues)
	End Method

	Method New(radius:Float, r:Float, g:Float, b:Float, initialValues:ParticleValues = Null, finalValues:ParticleValues = Null)
		Super.New(, initialValues, finalValues)
		Self.radius = radius
		Self.r = r; Self.g = g; Self.b = b
	End Method
	
	Method Clone:SolidParticle() Override
		Local p:= New SolidParticle(ttl, initial.Clone(), last.Clone())
		p.r = r; p.g = g; p.b = b
		p.radius = radius
		Return p
	End Method
	
	Method Update:Void() Override
		Super.Update()
	End Method
	
	Method Render:Void(canvas:Canvas,xOffset:Float = 0, yOffset:Float = 0) Override
		Local currentTime:Int = Millisecs() -startTime
		If currentTime >= ttl Then Return

		If currentTime < fadeIn  'Fade in
			canvas.Alpha = current.alpha * (currentTime / float(fadeIn))
		ElseIf currentTime + fadeOut > ttl  'Fade out
			Local fade:Float = (ttl - currentTime) / float(fadeOut)
			canvas.Alpha = Clamp(current.alpha * fade, 0.0, 1.0)
		Else  'Use normal alpha fade
			canvas.Alpha = current.alpha
		End If	
	
 
	
	
		canvas.Color =  New Color(r, g, b)
		canvas.BlendMode = blend
		canvas.DrawCircle(current.x + xOffset, current.y + yOffset, radius * current.scl)
		canvas.Color = Color.White
		canvas.Alpha = 1
		canvas.BlendMode = BlendMode.Alpha ' TODO MX2 port, this was blendmode 0 in mx1
	End Method
End Class

'Summary:  An implementation of a basic particle using images.
Class ImageParticle Extends BaseParticle
	Field img:Image
	
	Field fadeIn:Int, fadeOut:Int 'lengths to fade in and out when rendering.
	
	Method New(ttl:Int= 500, initialValues:ParticleValues = Null, finalValues:ParticleValues = Null)
		Super.New(ttl, initialValues, finalValues)
	End Method

	Method New(img:Image, initialValues:ParticleValues = Null, finalValues:ParticleValues = Null, ttl:Int = 500)
		Super.New(ttl, initialValues, finalValues)
		Self.img = img
	End Method
	
	Method Clone:ImageParticle() Override
		'Make a copy of this particle, but with a new startTime.
		Return New ImageParticle(img, initial.Clone(), last.Clone(), ttl)
	End Method
	
	Method Render:Void(canvas:Canvas,xOffset:Float = 0, yOffset:Float = 0) Override
		Local currentTime:Int = Millisecs() -startTime
		If currentTime >= ttl Then Return

		If currentTime < fadeIn  'Fade in
			canvas.Alpha = current.alpha * (currentTime / Cast<Float>(fadeIn))
		ElseIf currentTime + fadeOut > ttl  'Fade out
			Local fade:Float = (ttl - currentTime) / float(fadeOut)
			canvas.Alpha = Clamp(current.alpha * fade, 0.0, 1.0)
		Else  'Use normal alpha fade
			canvas.Alpha = current.alpha
		End If
		canvas.DrawImage(img, current.x, current.y, current.angle + current.spin, current.scl, current.scl)
		canvas.Alpha = 1
	End Method
End Class



'Summary:  An example of a basic particle factory.
Class SolidParticleFactory Implements ParticleFactory
	Field MinR:Float, MinG:Float, MinB:Float, MaxR:Float, MaxG:Float, MaxB:Float   'Color ranges

	Field pv:= New ParticleValues()   'Prototype values for a particle to spawn
	
	Method New(lr:Float, lg:Float, lb:Float, hr:Float, hg:Float, hb:Float)
		MinR = lr; MinG = lg; MinB = lb
		MaxR = hr; MaxG = hg; MaxB = hb
	End Method

	Method Spawn:Particle()
		Local dir:Float[] = PolarToRect(Rnd(2) + 2, Rnd(360))
		pv.x = Rnd(-2, 2); pv.y = Rnd(-2, 2)
		pv.dx = dir[0]; pv.dy = dir[1]
		
		Local p:SolidParticle = New SolidParticle(Rnd(8) + 4, Rnd(MinR, MaxR), Rnd(MinG, MaxG), Rnd(MinB, MaxB))
		p.ttl = Rnd(500) + 300
		p.initial = pv.Clone()
		p.current = pv.Clone()
		p.last = pv.Clone()
		
		p.fadeIn = 20
		p.fadeOut = Rnd(400) + 100
		p.radius = 4
		
		p.last.scl = Rnd(1) + 0.1
		p.last.gravY = Rnd(0.1)
		
'		'Uncomment this if you want additive blending.
'		#If TARGET="glfw"
'		 p.blend = 1
'		#End 
		
		Return p
	End Method
	
Private
'Summary:  Returns a 2-length array containing cartesian coordinates of a given polar coordinate.
Function PolarToRect:Float[] (r:Float, angle:Float)
	Local out:= New Float[](r * Cos(angle), r * Sin(angle))
	Return out
End Function
End Class

