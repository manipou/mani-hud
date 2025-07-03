<script lang="ts">
	import Minimap from "$lib/components/Minimap.svelte";
	import Compass from "$lib/components/Compass.svelte";
	import Stats from "$lib/components/Stats.svelte";
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&display=swap" rel="stylesheet">
</svelte:head>

<div class="relative h-screen w-full p-4 text-white font-sans" style="font-family: 'Share Tech', sans-serif;">
	<Minimap />
	<Compass />
	<Stats />
</div>