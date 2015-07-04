package org.aryalinux.parser.lfs;

import java.util.List;

import org.aryalinux.parser.commons.lfs.ScriptEngine;
import org.aryalinux.parser.commons.lfs.Step;
import org.aryalinux.parser.scriptengine.lfs.BLFSBasicSoftwareInstallerScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.CreatingBasicFilesAndDirectoriesScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.DeviceCustomSymlinkScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.EtcShellsScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.FirstBuildScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.InputrcGeneratorScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.LSBReleaseScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.LogFileCreatorScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.MainBuilderScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SystemdClockScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SystemdCustomScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SystemdFstabScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SystemdKernelScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SystemdLocaleScriptEngine;
import org.aryalinux.parser.scriptengine.lfs.SystemdNetworkScriptEngine;

public class SystemdStageScriptEngine {
	private StageScriptEngine stageScriptEngine;
	private static SystemdStageScriptEngine instance;

	private SystemdStageScriptEngine() {
		stageScriptEngine = StageScriptEngine.instance();
		stageScriptEngine.getScriptEngines().clear();
		stageScriptEngine.getScriptEngines().add(new FirstBuildScriptEngine());
		stageScriptEngine.getScriptEngines().add(new CreatingBasicFilesAndDirectoriesScriptEngine());
		stageScriptEngine.getScriptEngines().add(new LogFileCreatorScriptEngine());
		stageScriptEngine.getScriptEngines().add(new MainBuilderScriptEngine());
		stageScriptEngine.getScriptEngines().add(
				new SystemdNetworkScriptEngine());
		stageScriptEngine.getScriptEngines().add(new DeviceCustomSymlinkScriptEngine());
		stageScriptEngine.getScriptEngines()
				.add(new SystemdClockScriptEngine());
		stageScriptEngine.getScriptEngines().add(
				new SystemdLocaleScriptEngine());
		stageScriptEngine.getScriptEngines().add(new InputrcGeneratorScriptEngine());
		stageScriptEngine.getScriptEngines().add(new EtcShellsScriptEngine());
		stageScriptEngine.getScriptEngines().add(new SystemdCustomScriptEngine());
		stageScriptEngine.getScriptEngines().add(new SystemdFstabScriptEngine());
		stageScriptEngine.getScriptEngines().add(new SystemdKernelScriptEngine());
		stageScriptEngine.getScriptEngines().add(new LSBReleaseScriptEngine());
		stageScriptEngine.getScriptEngines().add(new BLFSBasicSoftwareInstallerScriptEngine());
	}

	public static SystemdStageScriptEngine instance() {
		return instance != null ? instance
				: (instance = new SystemdStageScriptEngine());
	}

	public void generate(List<Step> steps, String outputDirectory)
			throws Exception {
		for (ScriptEngine scriptEngine : stageScriptEngine.getScriptEngines()) {
			scriptEngine.generateScript(steps, outputDirectory);
		}
	}
}
