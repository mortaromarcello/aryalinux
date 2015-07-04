package org.aryalinux.parser.lfs;

import java.util.ArrayList;
import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.scriptengine.lfs.BLFSBasicSoftwareInstallerScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.BashProfileScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.BootScriptInstallerScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.CreatingBasicFilesAndDirectoriesScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.DeviceCustomSymlinkScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.EtcShellsScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.FirstBuildScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.InputrcGeneratorScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.LSBReleaseScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.LogFileCreatorScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.MainBuilderScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SysvinitClockAndConsoleScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SysvinitFstabScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SysvinitKernelScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SysvinitNetworkScriptEngine;

public class StageScriptEngine {
	private List<ScriptEngine> scriptEngines;
	private static StageScriptEngine instance;

	private StageScriptEngine() {
		scriptEngines = new ArrayList<ScriptEngine>();
		scriptEngines.add(new FirstBuildScriptEngine());
		scriptEngines.add(new CreatingBasicFilesAndDirectoriesScriptEngine());
		scriptEngines.add(new LogFileCreatorScriptEngine());
		scriptEngines.add(new MainBuilderScriptEngine());
		scriptEngines.add(new BootScriptInstallerScriptEngine());
		scriptEngines.add(new DeviceCustomSymlinkScriptEngine());
		scriptEngines.add(new SysvinitNetworkScriptEngine());
		scriptEngines.add(new SysvinitClockAndConsoleScriptEngine());
		scriptEngines.add(new BashProfileScriptEngine());
		scriptEngines.add(new InputrcGeneratorScriptEngine());
		scriptEngines.add(new EtcShellsScriptEngine());
		scriptEngines.add(new SysvinitFstabScriptEngine());
		scriptEngines.add(new SysvinitKernelScriptEngine());
		scriptEngines.add(new LSBReleaseScriptEngine());
		scriptEngines.add(new BLFSBasicSoftwareInstallerScriptEngine());
	}

	public static StageScriptEngine instance() {
		if (instance == null) {
			instance = new StageScriptEngine();
		}
		return instance;
	}

	public void generate(List<Step> steps, String outputDirectory)
			throws Exception {
		for (ScriptEngine engine : scriptEngines) {
			engine.generateScript(steps, outputDirectory);
		}
	}

	public List<ScriptEngine> getScriptEngines() {
		return scriptEngines;
	}

	public void setScriptEngines(List<ScriptEngine> scriptEngines) {
		this.scriptEngines = scriptEngines;
	}

}
