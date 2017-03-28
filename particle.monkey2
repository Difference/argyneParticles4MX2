' This file contains the base particle class and the Particle interface.  
' All particles should inherit from BaseParticle under most circumstances.
' If you're looking for basic particles which can be used in your games, 
' or to make your own particle types from, see basic_particles.monkey.
'	-nobu



'Summary:  All particles must implement this interface.
Interface Particle
	'Particle values.
	Property Initial:ParticleValues()  
	Property Current:ParticleValues()    
	Property Last:ParticleValues()  
 

	'Required members
	Property Dead:Bool() 
	
	'Required Methods		
	Method Clone:Object()
	Method Update:Void()
	Method Render:Void(canvas:Canvas,xOffset:Float = 0, yOffset:Float = 0)
	
	'Summary:  Translates the position of the partlce in all ParticleValues
	Method Translate:Void(firstX:Float, firstY:Float, lastX:Float, lastY:Float)
End Interface

'Summary:  The base Particle implementing-class. 
Class BaseParticle Implements Particle
	Field initial:= New ParticleValues()  'Initial values to use as permenant prototype
	Field current:= New ParticleValues() 'Values on current update
	Field last:= New ParticleValues()  'Final values
			
	Field startTime:Int, ttl:Int  'Initial creation time and time to live
	
	Field isDead:Bool             'Is set to TRUE when ttl has elapsed, for easy cleanup.
	Field DT:Float = 1.0 / Cast<Float>(60)  'Delta time target	' TODO MX2 port 60 was UpdateRate()
	Field frames:Float, percent:Float  'The number of frames since epoch, and the amount of percent from epoch-ttl.

	'#Region Satisfy the Particle interface requirement.
	Property Initial:ParticleValues()  'Get
		Return initial	
	Setter(value:ParticleValues)  'Set
		initial = value
	End Property	
	
	Property Current:ParticleValues()  'Get
		Return current
	Setter(value:ParticleValues)  'Set
		current = value	
	End Property	
 
	Property Last:ParticleValues()  'Get
		Return last
	Setter(value:ParticleValues)   'Set
		last = value		
	End Property	
	
 
	
	Property Dead:Bool()  
		Return isDead
	Setter (value:Bool)  
		isDead = value
	End Property
	'#End Region
	
		
	Method New(ttl:Int = 500, initialValues:ParticleValues = Null, finalValues:ParticleValues = Null)
		startTime = Millisecs()  'Set start to now.
		Self.ttl = ttl

			If initialValues <> Null Then
				initial = initialValues
				current = initialValues.Clone()
			End If
			If finalValues <> Null Then
				last = finalValues
			Else  'Set final values to initial values, if initial values exist.
				If initialValues <> Null Then finalValues = initialValues.Clone()
			End If
 
		
	End Method
		
	Method Clone:BaseParticle() Virtual
		'Make a copy of this particle, but with a new startTime.
		Print "HERR"
		Return New BaseParticle(ttl, initial.Clone(), last.Clone())
	 
	End Method

	Method Update:Void() Virtual
		'Avoid a divide by zero; if ttl is 0 then we don't need to update anyway.
		If ttl = 0 Then
			isDead = True
			Return
		End If
		
		'All values use delta time, even the ones which would normally be frame-time.
		'To achieve this, an estimated number of "frames" is calculated since epoch.
		'The percentage is calculated similarly, as a value 0-1 from epoch to ttl.
		frames = (Millisecs() -startTime) / (DT * 1000.0)
		percent = (Millisecs() -startTime) / float(ttl)

		If percent >= 1 Then isDead = True
					
		'Update all values.
		current.Set(initial, last, percent)  'First, apply transitory percentage values.

		'Now, let's apply frame-based values to alter/tweak the current positions.
		'Apply gravity to the delta values.
		current.dx += (current.gravX * frames)
		current.dy += (current.gravY * frames)

		current.x += (current.dx * frames)  'Apply delta X forces.
		current.y += (current.dy * frames)  'Apply delta Y forces.
		
		current.angle += (current.spin * frames) 'Apply delta rotation.		
	End Method
	
	Method Render:Void(canvas:Canvas,xOffset:Float = 0, yOffset:Float = 0) Virtual
		'NOTE:  Override me.	
	End Method

	Method Translate:Void(firstX:Float, firstY:Float, lastX:Float, lastY:Float)
		initial.x += firstX; initial.y += firstY
		last.x += lastX; last.y += lastY
	End Method
	
End Class
