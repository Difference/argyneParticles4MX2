'This class is the "Global" Particle Manager.  Its purpose is to maintain the active list of 
'Emitters for that instance of the particle system, and perform cleanup and memory management
'of the emitters so that the system doesn't exceed a certain size.  All emitters are added
'to the manager's stack



Class ParticleManager
	'TODO:  Add an instance-friendly way to count all particles and limit particles/emitters in the system.
	'TODO:  Make use of brl.pool to optimize de/allocation of particles and emitters

	Field Emitters:= New Stack<ParticleEmitter>   'Emitters in the system
	Field deademitters:= New Stack<ParticleEmitter> ' MX2 helper	
	'Summary:  Updates all of the emitters in the global emitter stack and performs cleanup.	
	Method Update:Void()
		
		deademitters.Clear()
		
		For Local i:Int = 0 Until Emitters.Length
			Local o:ParticleEmitter = Emitters.Get(i)
			'Update the emitter, and make sure to set its position to the topmost capsule.
			o.Update()

			'Kill emitters that are dead.
 
				If o.isDead Then deademitters.Add(o)
		Next
 
		
		For Local o:= Eachin deademitters
			Emitters.Remove(o)
		next	
		deademitters.Clear()

		
		
	End Method
	
	'Renders all of the particle emitters in the stack.
	Method Render:Void(canvas:Canvas,xOffset:Float = 0, yOffset:Float = 0)
		For Local o:ParticleEmitter = EachIn Emitters
			o.Render(canvas,xOffset, yOffset)
		Next		
	End Method

	'Summary:  Clears all of the particle emitters in the stack immediately.  Useful when changing screens.	
	Method ClearAll:Void()
		Emitters = New Stack<ParticleEmitter>
	End Method

End Class