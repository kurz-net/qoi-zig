# Learning Zig with QOI

## What is Zig?

[Zig](https://ziglang.org/) is a low level programming language, created by Andrew Kelley.
Its goal is to replace and improve upon the C programming language, one of the most infamous and popular
programming languages still to this day. Zig offers many modern features that the C language
does not have, while remaining a fairly simple and compact language. It tries to avoid overly complicated mechanisms,
which its competitors, such as [Rust](https://www.rust-lang.org/), are often critiqued for.

## What is QOI?

QOI is the "Quite OK Image Format". It is a novel file format for storing pixels of an image.
The author's ([Dominic Szabelewski](https://phoboslab.org/)) motivation behind QOI is that he wanted to find a drastically
more simple solution to storing images than the most popular and de-facto standard image formats PNG and JPG,
since they are very very complicated. To his surprise he found a way to achieve similar compression
rates with a huge (up to 50x) speed up. [The original blog post](https://phoboslab.org/log/2021/11/qoi-fast-lossless-image-compression)
has a lot more details and you should definitely check it out.

**Let's get started!**

## The Setup

*You can find the code for this article [here](https://github.com/kurz-net/qoi-zig).*

The original qoi is implemented in C, but since it received a lot of attention, there are already plenty
of implementations in other languages. I have not looked at the [zig implementation](https://github.com/MasterQ32/zig-qoi)
before finishing my version of the project. I will look at it at the end of this article to learn and compare both approaches.

### Utilities

To check out our work at the end, we will be using https://floooh.github.io/qoiview/qoiview.html.
You can drag'n drop your .qoi files and it will render them like any other image.

### Initializing the project

I will create a github repo, look for a [.gitignore for zig](https://github.com/ziglang/zig/blob/master/.gitignore)
and use the zig cli to initialize a new project.

Our application will compile to a binary that you can use to convert between PNG and QOI formats.

```bash
gh repo clone kurz-net/qoi-zig
cd qoi-zig
wget https://github.com/ziglang/zig/blob/master/.gitignore
zig init-exe
```

### The project structure

Since I am sure that the complexity of this project will grow along the way, the only functions we need to start
are "encode", "decode" and "hash". Later on we will add utilities to read and write PNG files, but to start off
we will put our 3 starter functions in our main file and probably put them in seperate files, should we do some refactoring.

### Setting up tests & benchmarks

My plan for testing is to download the test images that contain sample images in QOI and PNG format from the official website
https://qoiformat.org/qoi_test_images.zip. To compare my image with the one we know to be correct, we will create a SHA1
hash for both and compare them. If they match up, the images are identical.

```bash
wget https://qoiformat.org/qoi_test_images.zip
unzip qoi_test_images.zip
rm qoi_test_images.zip
```

Benchmarks are also available on the offical QOI website: https://qoiformat.org/benchmark/.

QOI measures its performance against the popular image utility libraries libpng and stbi.
Luckily both of them are C libraries and Zig can interface with them. So to have a bit of
fun we will compare our Zig implementation with [libpng](https://github.com/glennrp/libpng),
[stbi](https://github.com/nothings/stb) and the original QOI implementation, which is also written in C.

The original suite of test images for the benchmark is 1.1GB, but to keep things manageable we
will only run the benchmark on the test images that we just downloaded.

### The CLI

This is how I would like the CLI to work.

```bash
./qoi-zig image.png > image.qoi
./qoi-zig image.qoi > image.png
```

Our application will receive exactly one input, the path of the file to convert. If the file ends with
PNG, we will convert it to QOI, and the other way around.

Instead of the cli creating a QOI (or PNG) file, we will simply stdout the QOI image data, so that we can
direct it into our target file, but still have the option to pipe it through other tools.

## Writing some code

Now that we have an idea of what our project should look like at the end, let's get to implementing
it in Zig.

The first thing we should is think about our data. Especially, the shape we will want it to be in.
There are 2 ways we could go about storing our resulting image. Either we store it in an array or
a vector. The difference being, that the array is fixed in size, but a little faster. And the vector
being dynamically extendable, but a little slower. Since vectors are usually easier to work with and
do not require manual memory allocation, we will go with them.

Let's fill our files with the methods, inputs and outputs we want to them to contain at the end.

```zig
// src/main.zig

pub fn hash(data: []const u32) []const u8 {
    ...
}

pub fn encode(data: []const u32) anyerror!ArrayList(u32) {
    ...
}

pub fn decode(data: []const u32) anyerror!ArrayList(u32) {
    ...
}
```

### Hashing

Let's implement our hashing function. By doing a bit of googling we
can find that zig has a collection of cryptographic algorithms in the
standard library. Awesome, so how would we create a SHA1?

```zig
var hash: [20]u8 = undefined;
std.crypto.hash.Sha1.hash("our data to hash", &hash, .{});
std.log.info("our hash is: {s}", .{hash});
```
This is how we create a SHA1 hash in zig.

### The encoder

### The decoder

### Reading and writing PNGs

### The CLI - Putting it all together

Our main function will receive the stdin and, depending on the file extension, call the correct function to
encode / decode our QOI / PNG image.

```zig
// src/main.zig

pub fn main() anyerror!void {
}
```

### Benchmarks

## Comparing [kurz-net/qoi-zig](https://github.com/kurz-net/qoi-zig) to [MasterQ32/zig-qoi](https://github.com/MasterQ32/zig-qoi)

## Summary
