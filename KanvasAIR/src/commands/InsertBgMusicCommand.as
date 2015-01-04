package commands
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import model.CoreFacade;
	import model.SoundElment;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;

	/**
	 */	
	public class InsertBgMusicCommand extends Command
	{
		public function InsertBgMusicCommand()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			musicFile = new File;
			musicFile.browse([new FileFilter("音乐文件", "*.mp3")]);
			musicFile.addEventListener(Event.SELECT, fileSelected);
			
			UndoRedoMannager.register(this);
			this.dataChanged();
		}
		
		/**
		 */		
		private function fileSelected(evt:Event):void
		{
			CoreFacade.coreProxy.sound = new SoundElment;
			CoreFacade.coreProxy.sound.insertSound(musicFile.url, musicFile.name);
			
			this.sound = CoreFacade.coreProxy.sound;
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.coreProxy.sound = null;
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.coreProxy.sound = this.sound;
			this.dataChanged();
		}
		
		/**
		 */		
		private var sound:SoundElment;
		
		/**
		 */		
		private var musicFile:File;
	}
}