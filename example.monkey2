#Import "<std>"
#Import "<mojo>"

#Import "basic_particles"
#Import "emitter"
#Import "factory"
#Import "particle"
#Import "particlemanager"
#Import "particlevalues"


Using std..
Using mojo..

Class MyWindow Extends Window
	
	Field p:= New ParticleManager()
	Field f:= New SolidParticleFactory(0.5, 0, 1, 1, 0.1, 0.5)
	Field e:ParticleEmitter
	
	Field burst:Int  'Burst counter	
	

	Method New( title:String="Hello Particles",width:Int=640,height:Int=480,flags:WindowFlags=Null )

		Super.New( title,width,height,flags )
		
		'Set up the emitter
		e = New ParticleEmitter(f, 5000, 1)
		e.SetEmissions(e.emitInterval, 30, 50)	
		
	End
	
	Method OnMouseEvent ( event:MouseEvent ) Override
	


	
		If event.Type = EventType.MouseDown
			e.SetPosition(event.Location.x,event.Location.y)  'Set the emitter prototype's position.	
			Local ep:= e.Clone()  'Emitter clone
			ep.Emit()  'Force an emission.
			p.Emitters.Push(ep)  'Add the emitter clone to the manager's emitter stack.
		End If

		If burst > 0
			e.SetPosition(Rnd(Width), Rnd(Height))  'Set the emitter prototype's position.	
			Local ep:=  e.Clone()  'Emitter clone
			ep.Emit()  'Force an emission.
			p.Emitters.Push(ep)  'Add the emitter clone to the manager's emitter stack.
			burst -= 1
		End If
		
 
	
	End Method	
	
	Method OnKeyEvent ( event:KeyEvent ) Override  
	
		If event.Type = EventType.KeyDown
			Select event.Key
				Case Key.Space
					burst += 5
	 	
	'				If KeyHit(KEY_ESCAPE) or KeyHit(KEY_CLOSE) Then Error("")	
				
			End Select 	
		Endif
			
	
	End Method 

	Method OnRender( canvas:Canvas ) Override
		
		p.Update()   'Update the entire system.
	
		App.RequestRender()
	
		canvas.DrawText( "Hello Particles!",Width/2,Height/2,.5,.5 )
		
	 
		
		p.Render(canvas)		
		
	End
	
End

Function Main()

	New AppInstance
	
	New MyWindow
	
	App.Run()
End
 
 
 


 




