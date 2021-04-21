#include <iostream>
#include <time.h>
using namespace std;
#include <fstream>
#include <cmath>


//nvcc .\raytracing.cu -o raytracing
//.\raytracing

// limited version of checkCudaErrors from helper_cuda.h in CUDA examples
#define checkCudaErrors(val) check_cuda( (val), #val, __FILE__, __LINE__ )

void check_cuda(cudaError_t result, char const *const func, const char *const file, int const line) {
    if (result) {
        std::cerr << "CUDA error = " << static_cast<unsigned int>(result) << " at " <<
            file << ":" << line << " '" << func << "' \n";
        // Make sure we call CUDA Device Reset before exiting
        cudaDeviceReset();
        exit(99);
    }
}

__global__ void render(float *fb, int max_x, int max_y) {
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    int j = threadIdx.y + blockIdx.y * blockDim.y;
    if((i >= max_x) || (j >= max_y)) return;
    int pixel_index = j*max_x*3 + i*3;

    float u=float(i) / max_x;
    float v=float(j) / max_y;
    fb[pixel_index + 0] = u;
    fb[pixel_index + 1] = v;
    fb[pixel_index + 2] = 0.2;

    
    if(sqrt(pow(u-0.5,2)+pow(v-0.5,2))<0.25){
        fb[pixel_index + 0] = 1;
        fb[pixel_index + 1] = 0;
        fb[pixel_index + 2] = 0;
    }


}

int main() {
    int nx = 720;
    int ny = 720;
    int tx = 128;
    int ty = 8;

    std::cerr << "Rendering a " << nx << "x" << ny << " image ";
    std::cerr << "in " << tx << "x" << ty << " blocks.\n";

    int num_pixels = nx*ny;
    size_t fb_size = 3*num_pixels*sizeof(float);

    // allocate FB
    float *fb;
    checkCudaErrors(cudaMallocManaged((void **)&fb, fb_size));

    clock_t start, stop;
    start = clock();
    // Render our buffer
    dim3 blocks(nx/tx+1,ny/ty+1);
    dim3 threads(tx,ty);
    render<<<blocks, threads>>>(fb, nx, ny);
    checkCudaErrors(cudaGetLastError());
    checkCudaErrors(cudaDeviceSynchronize());
    stop = clock();
    double timer_seconds = ((double)(stop - start)) / CLOCKS_PER_SEC;
    std::cerr << "took " << timer_seconds << " seconds.\n";

    std::cerr << "begin saving the file.\n";

    ofstream ofs("first.ppm", ios_base::out | ios_base::binary);
    ofs << "P3" << endl << nx << ' ' << ny << endl << "255" << endl;

        for (int j = ny-1; j >= 0; j--) {
            for (int i = 0; i < nx; i++) {
                size_t pixel_index = j*3*nx + i*3;
                float r = fb[pixel_index + 0];
                float g = fb[pixel_index + 1];
                float b = fb[pixel_index + 2];
                int ir = int(255.99*r);
                int ig = int(255.99*g);
                int ib = int(255.99*b);
                ofs << ir << " " << ig << " " << ib << "\n";
            }
        }
    ofs.close();
    std::cerr << "finished!\n";

    checkCudaErrors(cudaFree(fb));
}

