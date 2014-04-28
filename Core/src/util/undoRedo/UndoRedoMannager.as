package util.undoRedo
{
	import flash.events.EventDispatcher;

	/**
	 * 撤销操作的管理器
	 */
	public class UndoRedoMannager extends EventDispatcher
	{
		/**
		 * 最多可撤销多少个命令
		 */		
		public static var maxCommandLen:uint = 50;
		
		/**
		 */		
		public static function onEnable(handler:Function):void
		{
			instance.addEventListener(UndoRedoEvent.ENABLE, handler, false, 0, true);
		}
		
		/**
		 */		
		public static function onDisable(handler:Function):void
		{
			instance.addEventListener(UndoRedoEvent.DISABLE, handler, false, 0, true);	
		}
		
		/**
		 * 注册可以撤销的指令
		 */		
		public static function register(command:ICommand):void
		{
			if (ifReady)
				instance.register(command);
		}
		
		/**
		 */		
		public static var ifReady:Boolean = false;
		
		/**
		 * 调用最新的撤销指令
		 */		
		public static function unDo():void
		{
			instance.unDo();
		}
		
		/**
		 */		
		public static function redo():void
		{
			instance.redo();
		}
		
		/**
		 */		
		private static function get instance():UndoRedoMannager
		{
			if (_instance == null)
				_instance = new UndoRedoMannager(new Key);
			
			return _instance;
		}
		
		/**
		 */		
		private static var _instance:UndoRedoMannager;
		
		/**
		 */		
		public function UndoRedoMannager(key:Key)
		{
		}
		
		/**
		 * 保存操作过的记录
		 */
		private function register(command:ICommand):void
		{
			cmdsForUndo.push(command);
			
			// 销毁掉多余的命令
			while (cmdsForUndo.length >= maxCommandLen)
				cmdsForUndo.shift();
			
			// 清空redo
			if (ifRedoEnable && cmdsForRedo.length)
			{
				ifRedoEnable = false;
				cmdsForRedo.length = 0;
				dispatchEvent(new UndoRedoEvent(UndoRedoEvent.DISABLE, "redo"));
			}
			
			if (ifUndoEnable == false && cmdsForUndo.length)
			{
				ifUndoEnable = true;
				this.dispatchEvent(new UndoRedoEvent(UndoRedoEvent.ENABLE, "undo"));
			}
		}
		
		/**
		 * 执行或重做了的命令会进入到撤销队列
		 */
		private function unDo():void
		{
			if (cmdsForUndo.length)
			{
				var command:ICommand = cmdsForUndo.pop();
				cmdsForRedo.push(command);
				command.undoHandler();
				
			}
			
			if (ifRedoEnable == false && cmdsForRedo.length)
			{
				ifRedoEnable = true;
				dispatchEvent(new UndoRedoEvent(UndoRedoEvent.ENABLE, "redo"));
			}
			
			if (ifUndoEnable && cmdsForUndo.length == 0)
			{
				ifUndoEnable = false;
				dispatchEvent(new UndoRedoEvent(UndoRedoEvent.DISABLE, "undo"));
			}
		}
		
		/**
		 * 撤销了的命令会进入redo队列， 
		 * 
		 * redo了的命令又回到撤销命令队列中
		 */		
		private function redo():void
		{
			if (cmdsForRedo.length)
			{
				var command:ICommand = cmdsForRedo.pop();
				cmdsForUndo.push(command);
				command.redoHandler();
			}
			
			if (ifUndoEnable == false && cmdsForUndo.length)
			{
				ifUndoEnable = true;
				dispatchEvent(new UndoRedoEvent(UndoRedoEvent.ENABLE, "undo"));
			}
			
			if (ifRedoEnable && cmdsForRedo.length == 0)
			{
				ifRedoEnable = false;
				dispatchEvent(new UndoRedoEvent(UndoRedoEvent.DISABLE, "redo"));
			}
			
		}
		
		/**
		 */		
		private var ifUndoEnable:Boolean = false;
		
		private var ifRedoEnable:Boolean = false;
		
		/**
		 */		
		private var cmdsForRedo:Vector.<ICommand> = new Vector.<ICommand>;
		
		/**
		 * 撤销命令
		 */
		private var cmdsForUndo:Vector.<ICommand> = new Vector.<ICommand>;
		
	}
}

/**
 */
class Key
{
	public function Key()
	{
		
	}
}