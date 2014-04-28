package util.undoRedo
{
	public interface ICommand
	{
		function undoHandler():void;
		function redoHandler():void;
			
	}
}