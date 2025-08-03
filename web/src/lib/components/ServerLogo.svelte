<script lang="ts">
	import { Hud } from '$lib/stores/VisibilityStore';
</script>

<div class="fixed top-[3vh] left-[2vh] flex flex-col items-start pointer-events-none font-['Inter'] select-none">
	{#if $Hud.ServerLogo}
		<div class="mb-[1vh]">
			<img 
				src={$Hud.ServerLogo} 
				alt="Server Logo" 
				class="h-[4vh] w-auto object-contain drop-shadow-lg"
			/>
		</div>
	{/if}
</div>