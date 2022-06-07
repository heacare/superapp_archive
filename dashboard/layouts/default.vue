<template>
  <div>
    <nav class="flex flex-row items-center p-6 bg-white sticky top-0 z-50 w-full">
      <img src="/logo.png" class="w-8" />
      <h1 class="text-gray-600 font-semibold text-md ml-2">Healer Dashboard</h1>
      <div class="ml-auto">
        <slot name="actions"></slot>
      </div>
    </nav>
    <main>
      <slot />
    </main>
  </div>
</template>
